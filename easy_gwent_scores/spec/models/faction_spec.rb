require 'rails_helper'

RSpec.describe Faction, type: :model do
  describe "Validations" do
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:name) }
  end
end
