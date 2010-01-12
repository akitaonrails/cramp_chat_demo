module ApplicationHelper
  private
  def formatted_msg(message)
    if message.is_a? Chat
      ["<div>
          <span class=\"from\">At #{message.sent_at.to_formatted_s(:short)}, #{message.name} said:</span>
          <span class=\"msg\">#{message.message}</span>
        </div>", "\n"]
    else
      ["<p>#{message}</p>", "\n"]
    end
  end
end