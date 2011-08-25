class RetrieveController < ApplicationController
  before_start :check_last_timestamp
  on_start :retrieve_messages
  
  def check_last_timestamp
    
    yield
  end
  
  def retrieve_messages
    @last_message_id = request.params["last_id"]
    messages = @last_message_id ? Chat.since(@last_message_id) : Chat.recent

    if messages.any?
      @last_message_id = messages.last.id

      list = messages.map { |msg| { "from" => msg.name, "msg" => msg.message, "sent" => msg.sent_at.to_formatted_s(:short), "id" => msg.id } }
      render list.to_json
    end

    finish
  end
  
end
