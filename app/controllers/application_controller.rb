class ApplicationController < Cramp::Action
  use_fiber_pool

  include ApplicationHelper
end

class WebSocketApplicationController < Cramp::Websocket
  use_fiber_pool

  include ApplicationHelper
end
