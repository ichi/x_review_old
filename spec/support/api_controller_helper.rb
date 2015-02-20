module ApiControllerHelper
  %w(get post put patch delete).each do |method|
    define_method "j#{method}" do |action, params = {}, session = {}|
      __send__ method, action, params.merge(format: :json), session
    end
  end
end

RSpec.configure do |config|
  config.include ApiControllerHelper, type: :controller
end
