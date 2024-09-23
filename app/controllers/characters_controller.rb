class CharactersController < ApplicationController
  before_action :authenticate_user!
  def index
    @characters = current_user.characters
  end

  def show
    @character = Character.find(params[:id])
  end

  def new
    @character = current_user.characters.build
  end

  def create
    @character = current_user.characters.build(character_params)
    @character.assign_spells_based_on_class
    @character.save
    if @character.save
      redirect_to characters_path, notice: "Character was successfully created."
    else
      render :new
    end
  end

  def destroy
    @character = Character.find(params[:id])
    @character.destroy
    redirect_to characters_path, notice: "Character was successfully deleted."
  end

  def heal
    def heal
      @character = Character.find(params[:id])
      @character.update(health: @character.max_health)
      flash[:notice] = "You have healed to full health!"
      redirect_to character_path(@character)
    end
  end

  def character_params
    params.require(:character).permit(:name, :character_class)
  end
end
