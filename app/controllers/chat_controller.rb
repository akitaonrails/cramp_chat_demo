class ChatController < WebSocketApplicationController
  periodic_timer :retrieve_messages, :every => 0.1
  on_data :receive_message
  
  def retrieve_messages
    messages = @last_message_id ? Chat.since(@last_message_id) : Chat.recent

    if messages.any?
      @last_message_id = messages.last.id

      list = messages.map { |msg| { "from" => msg.name, "msg" => msg.message, "sent" => msg.sent_at.to_formatted_s(:short) } }
      render list.to_json
    end
  end
  
  def receive_message(data)
    params = Rack::Utils.parse_query(data)
    
    chat = Chat.new :name => params["from"],
      :sent_at => Time.now,
      :message => params["msg"]

    if chat.save
      render formatted_msg("Message Successfully Received.")
    else
      render formatted_msg("Error receiving message: #{status.inspect}.")
    end
  end

end
