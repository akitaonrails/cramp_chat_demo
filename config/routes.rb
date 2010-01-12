def app_routes
  Rack::Builder.new do
    use Rack::Static, :urls => ["/public"]
    use Rack::Session::Cookie
    
    routes = Usher::Interface.for(:rack) do
      get('/websocket').to(ChatController)
      get('/retrieve').to(RetrieveController)
      post('/receive').to(ReceiveController)
      get('/(:file)').to(StaticController)
    end
    run routes
  end
end