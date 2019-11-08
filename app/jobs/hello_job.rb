class HelloJob < ApplicationJob
  queue_as :default

  after_perform :mail_hello

  def perform
    puts "hello"
  end

  def mail_hello
    HelloMailer.hello.deliver_now
  end
end

# Sidekiq::Cron::Job.create(name: 'Saying hello as a test', cron: '*/5 * * * *', class: 'HelloJob') # execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc
