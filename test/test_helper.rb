ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Helper method for parsing JSON data into a hash.
  def json_to_hash(body)
    JSON.parse(body, symbolize_names: true)
  end
end
