def app_routes
  Rack::Builder.new do
    use Rack::Static, :urls => ["/public"]
    use Rack::Session::Cookie
    
    map("/websocket") { run ChatController }
    map("/retrieve") { run RetrieveController }
    map("/receive") { run ReceiveController }
  end

end