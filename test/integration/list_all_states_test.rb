require 'test_helper'

class ListAllStatesTest < ActionDispatch::IntegrationTest
  # Makes a request to the main API endpoint, checks for expected response
  #  code, JSON content-type, correct number of States, and that the States'
  #  data is not empty.
  test 'Lists All States and Gas Prices' do
    get '/api/v1/states'

    states = json_to_hash(response.body)[:states]

    assert_equal     200,        response.status
    assert_equal     Mime::JSON, response.content_type
    assert_equal     50,          states.length
    assert_not_empty states[0][:name]
    assert_not_empty states[0][:price]
    assert_not_empty states[1][:name]
    assert_not_empty states[1][:price]
  end
end
