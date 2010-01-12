class ChatController < WebSocketApplicationController
  periodic_timer :retrieve_messages, :every => 2
  on_data :receive_message
  
  def retrieve_messages
    @last_message ||= (Time.now - 1.minute)
    Chat.recent(@last_message).all do |messages|
      list = messages.map { |msg| { "from" => msg.name, "msg" => msg.message, "sent" => msg.sent_at.to_formatted_s(:short) } }
      @last_message = messages.first.try(:sent_at) || @last_message
      render [list.to_json, "\n"]
    end
  end
  
  def receive_message(data)
    params = Rack::Utils.parse_query(data)
    
    chat = Chat.new :name => params["from"],
      :sent_at => Time.now,
      :message => params["msg"]

    chat.save do |status|
      if status.success?
        render formatted_msg("Message Successfully Received.")
      else
        render formatted_msg("Error receiving message: #{status.inspect}.")
      end
    end
  end
end