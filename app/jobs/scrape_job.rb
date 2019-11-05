class ScrapeJob < ApplicationJob

  queue_as :moon

  after_perform do |job|
    self.class.set(:wait => 1.minute).perform_later
  end

  def perform
    v = VoidScraper.new
    v.find_schedule
  end
end
