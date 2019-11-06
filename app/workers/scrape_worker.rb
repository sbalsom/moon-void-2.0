class ScrapeWorker
  include Sidekiq::Worker

  def perform
    puts "scraping the moon!"
  end
end
