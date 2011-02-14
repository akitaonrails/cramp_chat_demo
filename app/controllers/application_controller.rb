class ApplicationController < Cramp::Action
  include ApplicationHelper
end

class WebSocketApplicationController < Cramp::Websocket
  include ApplicationHelper
end
