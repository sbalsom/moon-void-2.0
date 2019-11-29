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

Sidekiq::Cron::Job.create(name: 'Monthly scrape for voids', cron: '*/20 18-23 1 * *', class: 'MonthlyScrapeJob')
Sidekiq::Cron::Job.create(name: 'Next day monthly scrape', cron: '*/20 0-5 2 * *', class: 'MonthlyScrapeJob')
