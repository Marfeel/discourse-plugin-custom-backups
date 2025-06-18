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
    end
end