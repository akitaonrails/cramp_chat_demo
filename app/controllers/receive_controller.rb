class ReceiveController < ApplicationController
  before_start :prepare_params
  on_start :receive_message
  
  def prepare_params
    @params = request.params
    yield
  end

  def receive_message
    chat = Chat.new :name => @params["from"],
      :sent_at => Time.now,
      :message => @params["msg"]

    if chat.save
      render formatted_msg("Message Successfully Received.")
    else
      render formatted_msg("Error receiving message: #{status.inspect}.")
    end

    finish

  end
end