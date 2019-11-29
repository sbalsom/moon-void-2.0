class WeeklyScrapeJob < ApplicationJob
  queue_as :default

  after_perform :mail_report

  def perform
    v = VoidScraper.new
    v.find_schedule
  end

  def mail_report
    NotificationMailer.report.deliver_now
  end
end

Sidekiq::Cron::Job.create(name: 'Weekly scrape for aspects', cron: '0 23 * * 7', class: 'WeeklyScrapeJob')
