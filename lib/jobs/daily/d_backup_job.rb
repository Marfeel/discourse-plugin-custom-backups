# lib/jobs/daily/d_backup_job.rb

module Jobs
  class DBackupJob < ::Jobs::Scheduled
    every 10.minutes

    def execute(args)
      return unless SiteSetting.d_backup_enable_daily_job

      Rails.logger.info("[DBackupJob] Running external backup script...")

      script_path = Rails.root.join("script", "run_local_backup.rb").to_s
      result = `bundle exec ruby #{script_path} 2>&1`

      if $?.success?
        Rails.logger.info("[DBackupJob] Script completed successfully:\n#{result}")
      else
        Rails.logger.error("[DBackupJob] Script failed:\n#{result}")
      end
    end
  end
end