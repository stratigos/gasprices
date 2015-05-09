class HomepageController < ApplicationController

  # PAGE CACHING UNAVAIL IN PRODUCTION (READONLY FS)
  # @see config/environments/production.rb
  # caches_page :index, :about

  def index
    expires_in 1.day, :public => true
    fresh_when last_modified: Time.parse('6am', 1.day.ago), :public => true
  end

  def about
    expires_in 1.day, :public => true
    fresh_when last_modified: Time.parse('6am', 1.day.ago), :public => true
  end
end
