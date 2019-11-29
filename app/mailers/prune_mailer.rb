class PruneMailer < ApplicationMailer
  def report
    @earliest_voids = Void.all.order(:end).first(5)
    @earliest_aspects = Aspect.all.order(:end_void).first(5)
    mail(to: 'solarbarmamaise@gmail.com', subject: 'Report after deleting voids')
  end
end
