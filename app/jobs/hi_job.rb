class HiJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker # enables job status tracking

  def perform(*args)
    puts "Hello from performing hi job"
    sleep 4
    puts "All done !"
  end
end
