class FactionSparseSerializer < ActiveModel::Serializer
  attributes :id, :name, :card_count
  def card_count
    object.cards.count
  end
end
