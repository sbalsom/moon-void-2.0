class ScrapeJob < ApplicationJob
  queue_as :moon

  after_perform do |job|
    # invoke another job at your time of choice
    self.class.set(wait: 1.week).perform_later
    mail_report
  end

  def perform
    v = VoidScraper.new
    v.find_schedule
  end

  def mail_report
    NotificationMailer.report.deliver_now
  end
end
