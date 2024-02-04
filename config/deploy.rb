lock "~> 3.18.0"

set :application, "qna"
set :repo_url, "git@github.com:Lesiantus/qna.git"
set :branch, 'sphinx'

set :deploy_to, "/home/lesiantus/qna"
set :deploy_user, "lesiantus"

append :linked_files, "config/database.yml", 'config/master.key'

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

set :pty, false

after 'deploy:publishing', 'unicorn:restart'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
