Discourse::Application.routes.append do
    post '/discourse-plugin-custom-backups/run' => 'backup_api/backups#create'
end