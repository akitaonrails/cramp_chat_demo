module ApplicationHelper
  def respond_with
    [200, {'Content-Type' => 'application/json'}]
  end
  
  private
  def formatted_msg(message)
    [[{ "message" => message }].to_json, "\n"]
  end
end