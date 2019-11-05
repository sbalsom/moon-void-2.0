class NotificationMailer < ApplicationMailer
  def report
    @aspects = Aspect.last(30)
    @voids = Void.last(30)
    mail(to: 'solarbarmamaise@gmail.com', subject: 'Report on last scraping job')
  end
end
