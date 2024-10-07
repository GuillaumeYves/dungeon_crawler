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
    @character.assign_novice_spells_based_on_class
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
    @character = Character.find(params[:id])
    @character.update(health: @character.max_health)
    @character.update(mana: @character.max_mana)
    flash[:notice] = "You feel refreshed"
    redirect_to character_path(@character)
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

  def take_item
    @character = Character.find(params[:id])
    item = Item.find(params[:item_id])

    # Add the item to the character's inventory
    @character.character_inventory << item

    # Optional: If you want to remove the item from the database after taking it
    item.destroy

    redirect_to character_path(@character), notice: "#{item.name} has been added to your inventory."
  end

  def take_scroll
    @character = Character.find(params[:id])
    scroll = Scroll.find(params[:scroll_id])

    # Add the scroll to the character's inventory
    inventory = @character.character_inventory

    scroll.update(character_inventory: inventory)

    redirect_to character_path(@character), notice: "#{scroll.name} has been added to your inventory."
  end

  def learn_scroll
    @character = Character.find(params[:id])
    @scroll = Scroll.find(params[:scroll_id])

    # Ensure character meets the required level to learn the scroll
    if @character.level >= @scroll.level_required
      # Logic to learn the scroll (e.g., adding the scroll's spell or ability to the character)
      # Assuming you have a method to handle learning the scroll
      @character.learn_scroll(@scroll)
      flash[:notice] = "#{@scroll.name} has been learned!"
    else
      flash[:alert] = "You need to be at least level #{@scroll.level_required} to learn this scroll."
    end

    redirect_to character_path(@character)
  end

  private

  def character_params
    params.require(:character).permit(:name, :character_class)
  end
end
