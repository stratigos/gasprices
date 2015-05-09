require 'test_helper'

class ListStateTest < ActionDispatch::IntegrationTest


  # Tests that New York State can be found by using the string, 'NY'.
  # States are created in ../fixtures/states.yml.
  test 'Lists NY State Gas Price By Abbreviated Name' do
    get '/api/v1/states/NY'

    state = State.find_by(name: json_to_hash(response.body)[:state][:name])

    assert_equal     200,        response.status
    assert_equal     Mime::JSON, response.content_type
    assert_equal     'NY',       state.name
    assert_not_empty state.price
  end

  # Tests that New York State can be found by using the string, 'New York'.
  test 'Lists NY State Gas Price By Full Name' do
    get '/api/v1/states/New%20York'

    state = State.find_by(name: json_to_hash(response.body)[:state][:name])

    assert_equal     200,        response.status
    assert_equal     Mime::JSON, response.content_type
    assert_equal     'NY',       state.name
    assert_not_empty state.price
  end

  # Tests that a State wont be found with an invalid name. Checks for HTTP
  #  Status code of '422', and expected error message.
  test 'Does Not List Invalid State' do
    get '/api/v1/states/NYC'

    err = json_to_hash(response.body)[:error]

    assert_equal 422,                response.status
    assert_equal Mime::JSON,         response.content_type
    assert_equal 'invalid argument', err
  end
end
