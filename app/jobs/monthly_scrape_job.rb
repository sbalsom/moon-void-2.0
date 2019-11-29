class MonthlyScrapeJob < ApplicationJob
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

Sidekiq::Cron::Job.create(name: 'Scraping for new data', cron: '*/30 */2 1 * *', class: 'MonthlyScrapeJob') # execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc
