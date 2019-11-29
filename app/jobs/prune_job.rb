class PruneJob < ApplicationJob
  queue_as :default

  after_perform :mail_hello

  def perform
    old_voids = Void.where('voids.end < ?', Time.now - 1.weeks)
    old_voids.destroy_all
    old_aspects = Aspect.where('aspects.end_void < ?', Time.now-1.weeks)
    old_aspects.destroy_all
  end

  def mail_hello
    PruneMailer.report.deliver_now
  end
end

Sidekiq::Cron::Job.create(name: 'Deleting old records', cron: '0 5 * * 1', class: 'PruneJob')
