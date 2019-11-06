class ScrapeJob < ApplicationJob
  queue_as :moon

  after_perform :mail_report

  def perform
    v = VoidScraper.new
    v.find_schedule
  end

  def mail_report
    NotificationMailer.report.deliver_now
  end
end
