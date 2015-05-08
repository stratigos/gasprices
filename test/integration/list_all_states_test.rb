require 'test_helper'

class ListAllStatesTest < ActionDispatch::IntegrationTest
  
  # setup do
  #   # create all states here?
  # end

  test 'Lists All States and Gas Prices' do
    get '/api/v1/states'

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
  end
end
