module BackupApi
    class BackupsController < ::ApplicationController
      requires_plugin 'discourse-plugin-custom-backups'

      before_action :ensure_admin

      def create
        script_path = Rails.root.join("script", "run_local_backup.rb").to_s
        result = `bundle exec ruby #{script_path} 2>&1`

        if $?.success?
          render json: { success: true, output: result }
        else
          render json: { success: false, error: result }, status: 500
        end
      end
    end
  end