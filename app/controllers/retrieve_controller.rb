class RetrieveController < ApplicationController
  on_start :retrieve_messages
  
  def retrieve_messages
    @last_message ||= (Time.now - 30.seconds)
    Chat.recent(@last_message).all do |messages|
      messages.each { |msg| render( formatted_msg(msg) ) }
      @last_message = messages.first.try(:sent_at) || @last_message
      finish
    end
  end
  
end