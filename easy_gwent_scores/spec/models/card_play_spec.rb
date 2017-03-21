require 'rails_helper'

RSpec.describe CardPlay, type: :model do
  it { is_expected.to belong_to(:board_side) }
  it { is_expected.to belong_to(:board_row) }
  it { is_expected.to belong_to(:card) }

end
