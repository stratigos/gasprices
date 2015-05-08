class StateSerializer < ActiveModel::Serializer
  # The following attributes represent what should be included in each API
  #  response for each State
  attributes :name, :price
end
