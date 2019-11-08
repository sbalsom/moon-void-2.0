class HelloJob < ApplicationJob
  queue_as :moon

  after_perform :mail_hello

  def perform
    v = VoidScraper.new
    v.find_schedule
  end

  def mail_hello
    HelloMailer.hello.deliver_now
  end
end
