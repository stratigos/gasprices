require 'test_helper'

class LoadHomepageTest < ActionDispatch::IntegrationTest
  test 'Loads Homepage' do
    get root_path

    assert_equal    200,         response.status
    assert_equal    Mime::HTML,  response.content_type
    assert_select   'a[href=?]', root_path, count: 2 # logo and nav
    assert_select   'a[href=?]', about_path
    assert_template 'homepage/index'
  end
end
