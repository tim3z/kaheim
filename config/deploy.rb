
set :application, 'kaheim'
set :repo_url, 'https://github.com/SDEagle/kaheim.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/kaheim/rails-kaheim'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.env config/master.key}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

rubyversion = File.open('.ruby-version', &:readline).gsub(/\n/, '')
# Default value for default_env is {}
set :default_env, { path: "/package/host/localhost/nodejs-9/bin:/package/host/localhost/#{rubyversion}/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 20

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :puma_init_active_record, true
