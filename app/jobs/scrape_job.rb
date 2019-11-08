require 'sidekiq-scheduler'


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

# do |job|
#     # invoke another job at your time of choice
#     self.class.set(wait: 30.seconds).perform_later
