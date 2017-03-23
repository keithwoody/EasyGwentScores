require 'rails_helper'

RSpec.describe BoardSide, type: :model do
  it { is_expected.to belong_to(:round) }
  it { is_expected.to have_many(:board_rows) }
  it { is_expected.to have_one :melee_row }
  it { is_expected.to have_one :ranged_row }
  it { is_expected.to have_one :siege_row }
  it { is_expected.to have_many :card_plays }
  it { is_expected.to have_many :global_card_plays }
  describe "after_create" do
    subject { create(:board_side) }
    it "is expected to have exactly 3 rows" do
      expect( subject.board_rows.count ).to eq 3
    end
  end

  describe "#play" do
    subject { create(:board_side) }
    let(:melee_row) { subject.melee_row }
    let(:ranged_row) { subject.ranged_row }
    let(:siege_row) { subject.siege_row }
    let(:unit5) { create(:unit, strength: 5) }
    let(:hero10) { create(:hero, strength: 10) }
    it "places a melee unit in the melee row" do
      unit5.combat_row = 'Close combat'
      expect{ subject.play(unit5) }.to change{ melee_row.cards.count }.from(0).to(1)
    end
    it "places a melee hero in the melee row" do
      hero10.combat_row = 'Close combat'
      expect{ subject.play(hero10) }.to change{ melee_row.cards.count }.from(0).to(1)
    end
    it "places a ranged unit in the ranged row" do
      unit5.combat_row = 'Ranged combat'
      expect{ subject.play(unit5) }.to change{ ranged_row.cards.count }.from(0).to(1)
    end
    it "places a ranged hero in the ranged row" do
      hero10.combat_row = 'Ranged combat'
      expect{ subject.play(hero10) }.to change{ ranged_row.cards.count }.from(0).to(1)
    end
    it "places a siege unit in the siege row" do
      unit5.combat_row = 'Siege'
      expect{ subject.play(unit5) }.to change{ siege_row.cards.count }.from(0).to(1)
    end
    it "places a siege hero in the siege row" do
      hero10.combat_row = 'Siege'
      expect{ subject.play(hero10) }.to change{ siege_row.cards.count }.from(0).to(1)
    end
    it "raises an error if no row is specified for an Agile card" do
      unit5.combat_row = 'Close or Ranged'
      expect{ subject.play(unit5) }.to raise_error(RuntimeError)
    end
    it "places an Agile card in the specified row" do
      hero10.combat_row = 'Close or Ranged'
      expect{ subject.play(hero10, row: melee_row) }.to change{ melee_row.cards.count }.by(1)
      expect{ subject.play(hero10, row: ranged_row) }.to change{ ranged_row.cards.count }.by(1)
    end

  end
end
