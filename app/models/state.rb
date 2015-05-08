# State is the datatype which holds the name and gas price for a US state
#  @see app/serializers/state_serializer.rb
class State < ActiveRecord::Base
  default_scope { order(:name) }

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { is: 2 }
  validates :price, presence: true
end
