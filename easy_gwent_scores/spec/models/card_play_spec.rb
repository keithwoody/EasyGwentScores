require 'rails_helper'

RSpec.describe CardPlay, type: :model do
  it { is_expected.to belong_to(:board_side) }
  it { is_expected.to belong_to(:board_row) }
  it { is_expected.to belong_to(:card) }

  let(:side_one) { create(:board_side) }
  let(:melee_row) { side_one.melee_row }
  let(:ranged_row) { side_one.ranged_row }
  let(:siege_row) { side_one.siege_row }
  let(:unit5) { create(:unit, strength: 5) }
  let(:hero10) { create(:hero, strength: 10) }
  let(:frost) { create(:frost) }
  let(:fog) { create(:fog) }
  let(:rain) { create(:rain) }
  let(:storm) { create(:storm) }
  let(:clear) { create(:clear_weather) }
  let(:horn) { create(:commanders_horn) }
  def create_play( card, row )
    side_one.card_plays.create(board_row: row, card: card)
  end
  describe "Callbacks:" do
    describe "after_create" do
      it "updates the row's score when a unit is played" do
        expect{ create_play(unit5, melee_row) }.to change{ melee_row.score }.from(0).to(5)
      end
      it "updates the row's score when a hero is played" do
        expect{ create_play(hero10, melee_row) }.to change{ melee_row.score }.from(0).to(10)
      end

      it "updates the melee row's unit scores when a frost is played" do
        create_play( unit5, melee_row )
        expect{ create_play(frost, nil) }.to change{ melee_row.score }.from(5).to(1)
      end
      it "updates the ranged row's unit scores when a fog is played" do
        create_play( unit5, ranged_row )
        expect{ create_play(fog, nil) }.to change{ ranged_row.score }.from(5).to(1)
      end
      it "updates the siege row's unit scores when a rain is played" do
        create_play( unit5, siege_row )
        expect{ create_play(rain, nil) }.to change{ siege_row.score }.from(5).to(1)
      end
      it "updates the ranged and siege rows' unit scores when a storm is played" do
        create_play( unit5, ranged_row )
        create_play( unit5, siege_row )
        expect{ create_play(storm, nil) }.to change{
          ranged_row.score + siege_row.score
        }.from(10).to(2)
      end

      it "activates Melee weather effects for Biting Frost" do
        expect{ side_one.card_plays.create(card: frost) }.to change{ side_one.melee_row.weather_active? }.from(false).to(true)
      end
      it "activates Ranged weather effects for Impenetrable Fog" do
        expect{ side_one.card_plays.create(card: fog) }.to change{ side_one.ranged_row.weather_active? }.from(false).to(true)
      end
      it "activates Siege weather effects for Torrential Rain" do
        expect{ side_one.card_plays.create(card: rain) }.to change{ side_one.siege_row.weather_active? }.from(false).to(true)
      end
      it "activates Ranged and Siege weather effects for Skellige Storm" do
        expect{ side_one.card_plays.create(card: storm) }.to change{
          side_one.ranged_row.weather_active? && side_one.siege_row.weather_active?
        }.from(false).to(true)
      end
      it "deactivates all weather effects for Clear Weather" do
        side_one.board_rows.update(weather_active: true)
        expect{ side_one.card_plays.create(card: clear) }.to change{
          melee_row.reload.weather_active? &&
          ranged_row.reload.weather_active? &&
          siege_row.reload.weather_active?
        }.from(true).to(false)
      end

      it "activates commander's horn doubling on the row where it was played" do
        expect{ create_play( horn, melee_row) }.to change {
          melee_row.commanders_horn_active?
        }.from(false).to(true)
        expect{ create_play( horn, ranged_row) }.to change {
          ranged_row.commanders_horn_active?
        }.from(false).to(true)
        expect{ create_play( horn, siege_row) }.to change {
          siege_row.commanders_horn_active?
        }.from(false).to(true)
      end
    end
  end

end
