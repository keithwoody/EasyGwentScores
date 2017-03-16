require 'rails_helper'

RSpec.describe Card, type: :model do
  subject { build(:card) }
  it { is_expected.to belong_to :faction }
  describe "Validations" do
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:name) }
  end
  describe "after_create" do
    subject { create(:card) }
    it "has a default strength" do
      expect( subject.reload.strength ).to eq 0
    end
  end
  describe "row_score" do
    it "defaults to value of strength" do
      expect( subject.row_score(nil) ).to eq subject.strength
    end
  end
end
