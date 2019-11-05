class NotificationMailer < ApplicationMailer
  def report
    @aspects = Aspect.where('created_at >= ? OR updated_at >= ?', Date.today.beginning_of_day - 1.days, Date.today.beginning_of_day - 1.days)
    @voids = Void.where('created_at >= ? OR updated_at >= ?', Date.today.beginning_of_day - 1.days, Date.today.beginning_of_day - 1.days)
    mail(to: 'solarbarmamaise@gmail.com', subject: 'Report on last scraping job')
  end
end
