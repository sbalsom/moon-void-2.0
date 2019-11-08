

class ScrapeWorker
  include Sidekiq::Worker

  def perform
    puts "scraping the moon!"
    NotificationMailer.report.deliver_now
  end
end
