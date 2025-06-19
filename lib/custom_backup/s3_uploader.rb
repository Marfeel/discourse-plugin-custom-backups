require 'aws-sdk-s3'

module CustomBackup
  class S3Uploader
    def self.upload(file_path)
      unless File.exist?(file_path)
        Rails.logger.error("[S3Uploader] Archivo no encontrado: #{file_path}")
        return
      end

      bucket = SiteSetting.discourse_plugin_custom_backups_s3_bucket.presence || 'my-test-bucket'
      key    = File.basename(file_path)

      s3 = Aws::S3::Client.new(
        region:            SiteSetting.discourse_plugin_custom_backups_s3_region.presence     || 'us-east-1',
        access_key_id:     SiteSetting.discourse_plugin_custom_backups_s3_access_key.presence || 'test',
        secret_access_key: SiteSetting.discourse_plugin_custom_backups_s3_secret_key.presence || 'test',
        endpoint:          SiteSetting.discourse_plugin_custom_backups_s3_endpoint.presence   || 'http://localhost:4566',
        force_path_style:  true
      )

      file_size = SiteSetting.discourse_plugin_custom_backups_s3_file_size.to_i || 200 # 200 MB
      chunk_size = file_size * 1024 * 1024
      parts = []
      file = File.open(file_path, 'rb')

      Rails.logger.info("[S3Uploader] Iniciando subida multipart a S3: #{file_path}")

      begin
        resp = s3.create_multipart_upload(bucket: bucket, key: key)
        upload_id = resp.upload_id
        part_number = 1

        until file.eof?
          part = file.read(chunk_size)
          Rails.logger.info("[S3Uploader] Subiendo parte ##{part_number} (#{(part.bytesize / 1024.0 / 1024).round(1)} MB)...")
          part_resp = s3.upload_part(
            bucket: bucket,
            key: key,
            upload_id: upload_id,
            part_number: part_number,
            body: part
          )
          parts << { etag: part_resp.etag, part_number: part_number }
          part_number += 1
        end

        s3.complete_multipart_upload(
          bucket: bucket,
          key: key,
          upload_id: upload_id,
          multipart_upload: { parts: parts }
        )

        Rails.logger.info("[S3Uploader] Subida completada con #{parts.size} partes.")

        File.delete(file_path)
        Rails.logger.info("[S3Uploader] Archivo local eliminado: #{file_path}")

      rescue => e
        Rails.logger.error("[S3Uploader] Error: #{e.message}")
        s3.abort_multipart_upload(bucket: bucket, key: key, upload_id: upload_id) if upload_id
      ensure
        file.close
      end
    end
  end
end