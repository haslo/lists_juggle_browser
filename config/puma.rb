rails_env = ENV['RAILS_ENV'] || 'development'
environment rails_env

threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count
port        ENV.fetch('PORT') { 3001 }
workers ENV.fetch('WEB_CONCURRENCY') { 1 }
plugin :tmp_restart

