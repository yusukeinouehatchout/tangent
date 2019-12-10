# capistranoのバージョン固定
lock "~> 3.11.2"

# デプロイするアプリケーション名
set :application, 'tangent'

# cloneするgitのレポジトリ
set :repo_url, 'https://github.com/yusukeinouehatchout/tangent.git'

# deployするブランチ。デフォルトはmasterなのでなくても可。
set :branch, 'master'

# deploy先のディレクトリ。
set :deploy_to, '/var/www/tangent'

# シンボリックリンクをはるファイル
set :linked_files, fetch(:linked_files, []).push('config/master.key')

# シンボリックリンクをはるフォルダ
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads/store')

# 保持するバージョンの個数
set :keep_releases, 5

# rubyのバージョン
# rbenvで設定したサーバー側のrubyのバージョン
set :rbenv_ruby, '2.5.1'
set :rbenv_custom_path, '/root/.rbenv'

# 出力するログのレベル。
set :log_level, :debug

# デプロイのタスク
namespace :deploy do

  # unicornの再起動
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  # データベースの作成
  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
                # データベース作成のsqlセット
                # データベース名はdatabase.ymlに設定した名前で
                sql = "CREATE DATABASE IF NOT EXISTS ContractApp_production;"
                # クエリの実行。
                # userとpasswordはmysqlの設定に合わせて
                execute "mysql --user=root --password=#{ENV["TANGENT_DB_PASSWORD"]} -e '#{sql}'"

        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end