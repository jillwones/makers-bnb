require 'twilio-ruby'

class Text
  def initialize(requester = Twilio::REST::Client)
    @requester = requester
    @client = requester.new('AC963f6312cf3100c6992e01cc3bb878cc', '5be91bf7584f70ae1933721875b04404')
  end

  def send_text_approved(number)
    message = @client.messages.create(
      body: "Your booking request has been accepted!",
      from: '+13022483728',
      to: "+#{number}"
    )

    puts message.sid
  end

  def send_text_rejected(number)
    message = @client.messages.create(
      body: "Your booking request has been denied...",
      from: '+13022483728',
      to: "+#{number}"
    )

    puts message.sid
  end

  def send_text_requested(number)
    message = @client.messages.create(
      body: "Somebody has requested to book one of your listings... Log in to MakersBnB to check it out...",
      from: '+13022483728',
      to: "+#{number}"
    )

    puts message.sid
  end
end
