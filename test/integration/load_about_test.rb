require 'test_helper'

class LoadAboutTest < ActionDispatch::IntegrationTest
  test 'Loads Homepage' do
    get about_path

    assert_equal    200,         response.status
    assert_equal    Mime::HTML,  response.content_type
    assert_template 'homepage/about'
  end
end
