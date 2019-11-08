require 'sidekiq-scheduler'

class HelloJob < ApplicationJob
  queue_as :moon

  after_perform :mail_hello

  def perform
    puts "hello"
  end

  def mail_hello
    HelloMailer.hello.deliver_now
  end
end
