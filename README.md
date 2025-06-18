# 🛡️ Local Backup Plugin for Discourse

This plugin adds the ability to create **local backups** of your Discourse instance without uploading them to S3 or deleting the resulting files.

It is useful for custom backup strategies, local storage, or development/testing scenarios.

---

## ⚠️ Disclaimer

This plugin is provided **“as is”** without any warranty or guarantee. Use it **at your own risk**.

The authors and contributors are **not responsible** for:
- Data loss
- Corruption
- Performance issues
- Unexpected behavior

We strongly recommend testing this plugin thoroughly in a **staging environment** before deploying to production.

---

## 🔧 Installation

1. Clone or add the plugin to your `plugins` directory:
   ```bash
   cd /var/www/discourse/plugins
   git clone https://github.com/your-org/discourse-plugin-custom-backups.git
   ```

2. Rebuild the container:
   ```bash
   ./launcher rebuild app
   ```

---

## 🛠️ Configuration

All plugin settings can be accessed from the Discourse admin panel:

**Admin > Settings > Plugins**

Available settings:

| Setting                       | Description                                                                 |
|------------------------------|-----------------------------------------------------------------------------|
| `discourse_plugin_custom_backups_dest_dir`          | Destination path for local backup files                                     |
| `discourse_plugin_custom_backups_enable_daily_job`  | Enables or disables the daily scheduled backup                              |
| `discourse_plugin_custom_backups_s3_enable`         | If enabled, also uploads the backup to an S3-compatible service             |
| `discourse_plugin_custom_backups_s3_access_key`     | S3 access key ID                                                            |
| `discourse_plugin_custom_backups_s3_secret_key`     | S3 secret access key (hidden in UI)                                        |
| `discourse_plugin_custom_backups_s3_region`         | AWS region for S3 bucket                                                    |
| `discourse_plugin_custom_backups_s3_endpoint`       | Custom endpoint for S3 (e.g., for local testing with MinIO or LocalStack)   |
| `discourse_plugin_custom_backups_s3_bucket`         | Name of the S3 bucket to upload backups to                                  |

---

## ▶️ Manual Usage

To trigger a local backup manually from the server:

```bash
cd /var/www/discourse
RAILS_ENV=production bundle exec ruby script/run_local_backup.rb
```

This will:
- Create a backup file (including uploads)
- Move it to the configured destination
- Optionally upload it to S3 if enabled

---

## ⏰ Scheduled Backups

If `discourse_plugin_custom_backups_enable_daily_job` is enabled, Discourse will automatically run the backup script once per day via the Sidekiq scheduler.

Make sure:
- Sidekiq is running
- Plugin is installed and loaded properly
- Site settings are configured correctly

---

## 📂 Output

Backup files will be stored in the directory configured by `discourse_plugin_custom_backups_dest_dir`.

Example:
```
/var/discourse/custom_backup/backup-2025-06-18-145320.tar.gz
```

---

## 🤝 Contributing

Pull requests and suggestions are welcome!

---