def app_routes
  Usher::Interface.for(:rack) do
    get('/').to(ChatController)
    get('/retrieve').to(RetrieveController)
    post('/receive').to(ReceiveController)
  end
  
  # Rack::Builder.new do
  #   use Rack::Static, :urls => ["/demo"]
  #   use Rack::Session::Cookie
  #   
  #   routes = Usher::Interface.for(:rack) do
  #     get('/').to(ChatController)
  #     get('/retrieve').to(RetrieveController)
  #     post('/receive').to(ReceiveController)
  #   end
  #   run routes
  # end
  
  # Rack::Builder.new do
  #   use Rack::ContentType, "text/html"
  #   use Rack::Static, :urls => ["/demo"]
  #   use Rack::Session::Cookie
  #   
  #   map("/") { run RetrieveController }
  #   map("/retrieve") { run RetrieveController }
  #   map("/receive") { run ReceiveController }
  # end

end