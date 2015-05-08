class BookSerializer < ActiveModel::Serializer
  # The following attributes represent what should be included in each API
  #  response for each State
  attributes :id, :name, :price
end
