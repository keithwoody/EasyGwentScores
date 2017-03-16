class Faction < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: true

  has_many :cards, inverse_of: :faction

end
