class ScrapeJob < ApplicationJob
  queue_as :moon

  after_perform do |job|
    NotificationMailer.report.deliver_now
    self.class.set(wait: job.arguments.first).perform_later if job.arguments.first
  end

  def perform(*wait_time)
    v = VoidScraper.new
    v.find_schedule
  end
end

