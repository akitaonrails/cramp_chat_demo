def app_routes
  Rack::Builder.new do
    use Rack::Session::Cookie
    
    routes = Usher::Interface.for(:rack) do
      get('/websocket').to(ChatController)
      get('/retrieve').to(RetrieveController)
      post('/receive').to(ReceiveController)
      get('/(:file)').to(StaticController)
    end

    file_server = Rack::File.new(File.join(File.dirname(__FILE__), '../public/'))

    run Rack::Cascade.new([file_server, routes])
  end
end