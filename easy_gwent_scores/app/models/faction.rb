class Faction < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: true

  has_many :cards, dependent: :destroy, inverse_of: :faction

end
