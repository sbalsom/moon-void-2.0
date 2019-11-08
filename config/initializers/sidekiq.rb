require 'sidekiq'
require 'sidekiq-status'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 7.days # default
  end
  config.redis = { namespace: 'Moon-Void', url: (ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379/1') }
  # config.on(:startup) do
  #   schedule_file = 'config/schedule.yml'
  #   if File.exist?(schedule_file)
  #     Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  #   end
  # end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 7.days
  end
  config.redis = { namespace: 'Moon-Void', url: (ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379/1') }
  # config.on(:startup) do
  #   schedule_file = 'config/schedule.yml'
  #   if File.exist?(schedule_file)
  #     Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  #   end
  # end
end
