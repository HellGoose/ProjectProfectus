class MessengerBotController < ActionController::Base
  force_ssl
  def message(event, sender)
    puts "message"
    puts "#{event}"
    puts "#{sender}"
    
    # profile = sender.get_profile
    sender.reply({ text: "Reply: #{event['message']['text']}" })
  end

  def delivery(event, sender)
    puts "delivery"
    puts "#{event}"
    puts "#{sender}"
    
  end

  def postback(event, sender)
    puts "postback"
    puts "#{event}"
    puts "#{sender}"
    
    payload = event["postback"]["payload"]
    case payload
    when :something
      #ex) process sender.reply({text: "button click event!"})
    end
  end
end
