class ApplicationController < Cramp::Controller::Action
  include ApplicationHelper
end

class WebSocketApplicationController < Cramp::Controller::Websocket
  include ApplicationHelper
end