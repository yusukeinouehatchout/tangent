# #unicornのpidファイル、設定ファイルのディレクトリを指定
# namespace :unicorn do
#   task :environment do
#     set :unicorn_pid,    "#{current_path}/tmp/pids/unicorn.pid"
#     set :unicorn_config, "#{current_path}/config/unicorn/production.rb"
#   end

# #unicornをスタートさせるメソッド
#   def start_unicorn
#     within current_path do
#       execute :bundle, :exec, :unicorn, "-c #{fetch(:unicorn_config)} -E #{fetch(:rails_env)} -D"
#     end
#   end

# #unicornを停止させるメソッド
#   def stop_unicorn
#     execute :kill, "-s QUIT $(< #{fetch(:unicorn_pid)})"
#   end

# #unicornを再起動するメソッド
#   def reload_unicorn
#     execute :kill, "-s USR2 $(< #{fetch(:unicorn_pid)})"
#   end

# #unicronを強制終了するメソッド
#   def force_stop_unicorn
#     execute :kill, "$(< #{fetch(:unicorn_pid)})"
#   end

# #unicornをスタートさせるtask
#   desc "Start unicorn server"
#   task start: :environment do
#     on roles(:app) do
#       start_unicorn
#     end
#   end

# #unicornを停止させるtask
#   desc "Stop unicorn server gracefully"
#   task stop: :environment do
#     on roles(:app) do
#       stop_unicorn
#     end
#   end

# #既にunicornが起動している場合再起動を、まだの場合起動を行うtask
#   desc "Restart unicorn server gracefully"
#   task restart: :environment do
#     on roles(:app) do
#       if test("[ -f #{fetch(:unicorn_pid)} ]")
#         reload_unicorn
#       else
#         start_unicorn
#       end
#     end
#   end

# #unicornを強制終了させるtask
#   desc "Stop unicorn server immediately"
#   task force_stop: :environment do
#     on roles(:app) do
#       force_stop_unicorn
#     end
#   end
# end


# #サーバ上でのアプリケーションコードが設置されているディレクトリを変数に入れておく
# app_path = File.expand_path('../../../', __FILE__)

# #アプリケーションサーバの性能を決定する
# worker_processes 1

# # currentを指定
# working_directory "#{app_path}/current"

# #Unicornの起動に必要なファイルの設置場所を指定
# pid "#{app_path}/shared/tmp/pids/unicorn.pid"

# #ポート番号を指定
# listen "#{app_path}/shared/tmp/sockets/unicorn.sock"

# #エラーのログを記録するファイルを指定
# stderr_path "#{app_path}/shared/log/unicorn.stderr.log"

# #通常のログを記録するファイルを指定
# stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

# #Railsアプリケーションの応答を待つ上限時間を設定
# timeout 999999999999

# #以下は応用的な設定なので説明は割愛

# preload_app true
# GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

# check_client_connection false

# run_once = true

# before_fork do |server, worker|
#   defined?(ActiveRecord::Base) &&
#     ActiveRecord::Base.connection.disconnect!

#   if run_once
#     run_once = false # prevent from firing again
#   end

#   old_pid = "#{server.config[:pid]}.oldbin"
#   if File.exist?(old_pid) && server.pid != old_pid
#     begin
#       sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
#       Process.kill(sig, File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH => e
#       logger.error e
#     end
#   end
# end

# after_fork do |_server, _worker|
#   defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
# end
