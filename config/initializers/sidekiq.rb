require 'sidekiq'
require 'sidekiq-status'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
  # config.redis = { namespace: 'Moon-Void', url: 'redis://127.0.0.1:6379/1' }
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
  # config.redis = { namespace:'Moon-Void', url: 'redis://127.0.0.1:6379/1' }
end


# Sidekiq.configure_server do |config| config.redis = { url: (ENV["REDIS_URL"] || 'redis://localhost:6379/0') } end

# Sidekiq.configure_client do |config| config.redis = { url: (ENV["REDIS_URL"] || 'redis://localhost:6379/0') } end

# 'redis://127.0.0.1:6379/1'
