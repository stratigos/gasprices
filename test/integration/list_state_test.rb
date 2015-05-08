require 'test_helper'

class ListStateTest < ActionDispatch::IntegrationTest

  # setup do
  #   # create a state here, NY?
  # end
  
  test 'Lists NY State Gas Price' do
    get '/api/v1/states/NY'

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    # more tbd...
  end
end
