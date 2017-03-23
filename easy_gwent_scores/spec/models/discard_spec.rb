require 'rails_helper'

RSpec.describe Discard, type: :model do
  it { is_expected.to belong_to(:board_side) }
  it { is_expected.to belong_to(:card) }

end
