Discourse::Application.routes.append do
    post '/discourse-plugin-custom-backups/run' => 'backup_api/backups#create'
    get  '/discourse-plugin-custom-backups/list' => 'backup_api/backups#index'
end