class CharactersController < ApplicationController
  before_action :authenticate_user!
  def index
    @characters = current_user.characters
  end

  def show
    @character = Character.find(params[:id])
    @spells = @character.spells
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

  def upgrade_spell
    @character = Character.find(params[:id])
    spell = @character.spells.find(params[:spell_id])
    if @character.skill_points > 0 && spell.rank < 5
      spell.rank += 1
      spell.damage = (spell.damage * 1.25).to_i
      spell.mana_cost = (spell.mana_cost * 1.25).to_i
      spell.save
      @character.update(skill_points: @character.skill_points - 1)
      flash[:notice] = "#{spell.name} has been upgraded to rank #{spell.rank}!"
    else
      flash[:alert] = "Cannot upgrade #{spell.name}. Insufficient skill points or already max rank."
    end

    redirect_to character_path(@character)
  end

  private

  def character_params
    params.require(:character).permit(:name, :character_class)
  end
end
