class RetrieveController < ApplicationController
  before_start :check_last_timestamp
  on_start :retrieve_messages
  
  def check_last_timestamp
    @last_message = Time.parse(request.params["last_timestamp"]) rescue nil
    yield
  end
  
  def retrieve_messages
    @last_message ||= (Time.now - 30.seconds)
    Chat.recent(@last_message).all do |messages|
      list = messages.map { |msg| { "from" => msg.name, "msg" => msg.message, "sent" => msg.sent_at.to_formatted_s(:short), "timestamp" => msg.sent_at } }
      if list.size > 0
        @last_message = messages.first.try(:sent_at) || @last_message
        render list.to_json
      end
      finish
    end
  end
  
end
