class FactionsController < ApplicationController
  before_action :set_faction, only: [:show]

  # GET /factions
  def index
    @factions = Faction.all

    render json: @factions, each_serializer: FactionSparseSerializer
  end

  # GET /factions/1
  def show
    render json: @faction
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faction
      @faction = Faction.find(params[:id])
    end

end
