require 'aws-sdk-s3'

module BackupApi
    class BackupsController < ::ApplicationController
      requires_plugin 'discourse-plugin-custom-backups'

      before_action :ensure_admin
      skip_before_action :verify_authenticity_token, only: [:create]

      def create
        script_path = Rails.root.join("script", "run_local_backup.rb").to_s
        Process.spawn("bundle exec ruby #{script_path} > log/local_backup.log 2>&1")
        render json: { success: true, message: "Backup running in background." }
      end

      def index
        bucket = SiteSetting.discourse_plugin_custom_backups_s3_bucket

        s3 = Aws::S3::Client.new(
          region:            SiteSetting.discourse_plugin_custom_backups_s3_region,
          access_key_id:     SiteSetting.discourse_plugin_custom_backups_s3_access_key,
          secret_access_key: SiteSetting.discourse_plugin_custom_backups_s3_secret_key,
          endpoint:          SiteSetting.discourse_plugin_custom_backups_s3_endpoint,
          force_path_style:  true
        )

        begin
          objects = s3.list_objects_v2(bucket: bucket).contents

          backup_list = objects.map do |obj|
            {
              filename: obj.key,
              last_modified: obj.last_modified,
              size: obj.size,
            }
          end

          render json: backup_list, layout: false
        rescue Aws::S3::Errors::ServiceError => e
          render json: { error: "Error getting backups: #{e.message}" }, status: 500
        end
      end

    end
end
