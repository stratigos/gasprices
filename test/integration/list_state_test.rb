require 'test_helper'

class ListStateTest < ActionDispatch::IntegrationTest

  # States are created in ../fixtures/states.yml 
  test 'Lists NY State Gas Price By Abbreviated Name' do
    get '/api/v1/states/NY'

    byebug

    state = json_to_hash(response.body)[:state]

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    # more tbd...
  end

  test 'Lists NY State Gas Price By Full Name' do
    get '/api/v1/states/New%20York'

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    # more tbd...
  end
end
