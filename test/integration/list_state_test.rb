require 'test_helper'

class ListStateTest < ActionDispatch::IntegrationTest

  # States are created in ../fixtures/states.yml 
  test 'Lists NY State Gas Price By Abbreviated Name' do
    get '/api/v1/states/NY'

    state = State.find_by(name: json_to_hash(response.body)[:state][:name])

    assert_equal     200,        response.status
    assert_equal     Mime::JSON, response.content_type
    assert_equal     'NY',       state.name
    assert_not_empty state.price
  end

  test 'Lists NY State Gas Price By Full Name' do
    get '/api/v1/states/New%20York'

    state = State.find_by(name: json_to_hash(response.body)[:state][:name])

    assert_equal     200,        response.status
    assert_equal     Mime::JSON, response.content_type
    assert_equal     'NY',       state.name
    assert_not_empty state.price
  end

  test 'Does Not List Invalid State' do
    get '/api/v1/states/NYC'

    assert_equal 422,        response.status
    assert_equal Mime::JSON, response.content_type
  end
end
