class NotificationMailer < ApplicationMailer
  def report
    @earlest_voids = Void.all.order(:end).first(5)
    @earliest_aspects = Void.all.order(:void_end).first(5)
    mail(to: 'solarbarmamaise@gmail.com', subject: 'Report after deleting voids')
  end
end
