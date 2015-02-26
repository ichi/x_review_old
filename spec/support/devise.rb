require 'devise'

module Devise
  module ControllerMacros
    def login_user
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        u = current_user rescue create(:user)
        sign_in u
      end
    end
  end

  module RequestMacros
    def login_user
      before(:each) do
        u = current_user rescue create(:user)
        login_as u, scope: :user, :run_callbacks => false
      end
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend  Devise::ControllerMacros, :type => :controller
  config.extend  Devise::RequestMacros, :type => :request
end
