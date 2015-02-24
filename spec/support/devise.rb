require 'devise'

module Devise
  module ControllerMacros
    def login_user(_user = nil)
      let(:logged_in_user){ _user || create(:user) }

      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in logged_in_user
      end
    end
  end

  module RequestMacros
    def login_user(_user = nil)
      let(:logged_in_user){ _user || create(:user) }

      before(:each) do
        login_as logged_in_user, scope: :user, :run_callbacks => false
      end
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend  Devise::ControllerMacros, :type => :controller
  config.extend  Devise::RequestMacros, :type => :request
end
