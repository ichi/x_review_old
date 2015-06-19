module ApiRequest
  module ControllerHelpers
    %w(get post put patch delete).each do |method|
      define_method "j#{method}" do |action, params = {}, session = {}|
        __send__ method, action, params.merge(format: :json), session
      end
    end
  end

  module RequestHelpers
    %w(get post put patch delete).each do |method|
      define_method "j#{method}" do |action, params = {}, headers_or_env  = {}|
        __send__ method, action, params, headers_or_env.merge("Accept" => "application/json")
      end
    end
  end
end

RSpec.configure do |config|
  config.include ApiRequest::ControllerHelpers, type: :controller
  config.include ApiRequest::RequestHelpers, type: :request
end
