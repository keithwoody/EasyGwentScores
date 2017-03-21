require 'rails_helper'

RSpec.describe BoardRow, type: :model do
  it { is_expected.to belong_to(:board_side) }
  it { is_expected.to have_many(:card_plays) }
  it { is_expected.to have_many(:cards).through(:card_plays) }
  it { is_expected.to validate_presence_of(:combat_type) }
  it { is_expected.to validate_uniqueness_of(:combat_type).scoped_to(:board_side_id) }
  it { is_expected.to validate_inclusion_of(:combat_type).in_array(BoardRow::COMBAT_TYPES) }

end
