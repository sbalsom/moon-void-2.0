desc "This task is called by the Heroku scheduler add-on"
task :scrape_for_data => :environment do
  puts "Scraping for data"
  ScrapeJob.perform_now
  puts "done."
end


