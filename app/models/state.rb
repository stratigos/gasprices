# State is the datatype which holds the name and gas price for a US state
#  @see app/serializers/state_serializer.rb
class State < ActiveRecord::Base
  validates :name, presence: true
  validates :price, presence: true
end
