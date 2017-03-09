class FactionSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :cards
  def cards
    object.cards.order(:strength, :name)
  end
  class CardSerializer < ActiveModel::Serializer
    attributes :id, :name, :strength
  end
end
