class HelloMailer < ApplicationMailer
  def hello
    @message = "Testing 1 2 3..."
    mail(to: 'solarbarmamaise@gmail.com', subject: 'Test email')
  end
end
