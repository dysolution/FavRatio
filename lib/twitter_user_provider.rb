require 'stub_helper'

class TwitterUserProvider
  include StubHelper

  def initialize
    RSpec::Mocks::setup(self)
  end
    
  def mock_instance(uid)
    user = mock("user_#{uid}")
    create_string_stubs(uid, user, %w(id screen_name profile_image_url))
    user
  end
end
