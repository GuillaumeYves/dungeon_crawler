class DungeonController < ApplicationController
  before_action :authenticate_user!
  before_action :set_character, only: [ :show, :take_turn ]
  before_action :set_monster, only: [ :take_turn ]

  def show
    @monster = generate_monster(@character.dungeon_stage)
    session[:monster_id] = @monster.id
    session[:monster_health] = @monster.health
    session[:monster_stats] = {
      min_physical_damage: @monster.min_physical_damage,
      max_physical_damage: @monster.max_physical_damage,
      armor: @monster.armor,
      magic_resistance: @monster.magic_resistance
    }
  end

  def fight
    @character = current_user.characters.find(params[:id])
    @monster = Monster.find(params[:monster_id])
    initialize_battle_state
  end


  def take_turn
    @character.turn_start_reduce_cooldowns
    case params[:action_type]
    when "attack"
      character_attack
      handle_battle_outcomes
      toggle_turn
      monster_attack if session[:monster_health] > 0
      handle_battle_outcomes
    when "spell"
      character_spellcast
      handle_battle_outcomes
      toggle_turn
      monster_attack if session[:monster_health] > 0
      handle_battle_outcomes
    when "flee"
      @result = "You fled from the battle!"
      redirect_to dungeon_character_path(@character) and return
    end
    toggle_turn
    render :fight
  end

  private

  def set_character
    @character = current_user.characters.find(params[:id])
  end

  def set_monster
    @monster = Monster.find(session[:monster_id])
  end

  def initialize_battle_state
    @character.spells.where(unlocked: true).update_all(cooldown: 0)

    session[:messages] = nil
    session[:messages] = []
    session[:monster_id] = @monster.id
    session[:monster_health] = @monster.health
    session[:turn] = "character"

    session[:frenzy_stacks] = 0
    session[:frenzy_damage] = 0
  end

  def generate_monster(stage)
    base_health = 100
    min_physical_damage = 15
    max_physical_damage = 20
    base_armor = 5
    base_magic_resistance = 5
    scaling_factor = 1.10
    @monster = Monster.create(
      name: Monster::MONSTER_NAMES.sample,
      health: (base_health * (scaling_factor ** (stage - 1))).to_i,
      max_health: (base_health * (scaling_factor ** (stage - 1))).to_i,
      min_physical_damage: (min_physical_damage * (scaling_factor ** (stage - 1))).to_i,
      max_physical_damage: (max_physical_damage * (scaling_factor ** (stage - 1))).to_i,
      armor: (base_armor * (scaling_factor ** (stage - 1))).to_i,
      magic_resistance: (base_magic_resistance * (scaling_factor ** (stage - 1))).to_i
    )
    @monster.save
    @monster
  end

  def check_attack_status
  end

  def character_attack
    damage_roll = 0
    if %w[warrior rogue].include?(@character.character_class)
      damage_roll =   rand(@character.min_physical_damage..@character.max_physical_damage)
      damage_type = "physical"
    elsif %w[mage].include?(@character.character_class)
      damage_roll =   rand(@character.min_magic_damage..@character.max_magic_damage)
      damage_type = "magic"
    end
    has_crit = false
    if rand(0..100) <= @character.critical_strike_chance
      damage_roll = (damage_roll * @character.critical_strike_damage).to_i
      has_crit = true
    end
    damage = (damage_roll - @monster.armor).to_i
    [ session[:monster_health] -= damage, 0 ].max
    message = "You attack #{@monster.name} for #{damage} #{damage_type} damage!"
    message.prepend("CRITICAL STRIKE! ") if has_crit
    session[:messages] << message
    trim_messages
  end

  def character_spellcast
    damage_roll = 0
    damage = 0
    has_crit = false
    spell_name = params[:spell_name]
    spell = @character.spells.find_by(name: spell_name)
    if @character.cannot_cast?(spell)
      session[:messages] << "You can't cast #{spell_name} right now!"
      return
    end
    @character.mana -= spell.mana_cost
    spell.update(cooldown: spell.base_cooldown)
    if spell.damage_type == "physical"
      damage_roll = ((rand(@character.min_physical_damage..@character.max_physical_damage)) + spell.damage).to_i
        if spell.name == "Frenzy"
          damage_roll = ((rand(@character.min_physical_damage..@character.max_physical_damage) + spell.damage + session[:frenzy_damage])).to_i
          unless session[:frenzy_stacks] >= 5
              session[:frenzy_damage] += 5
              session[:frenzy_stacks] += 1
          end
        end
      if rand(0..100) <= @character.critical_strike_chance
        damage_roll = (damage_roll * @character.critical_strike_damage).to_i
        has_crit = true
      end
      damage = (damage_roll - @monster.armor).to_i
    elsif spell.damage_type == "magic"
      damage_roll = ((rand(@character.min_magic_damage..@character.max_magic_damage)) + spell.damage).to_i
        if rand(0..100) <= @character.critical_strike_chance
          damage_roll = (damage_roll * @character.critical_strike_damage).to_i
          has_crit = true
        end
      damage = (damage_roll - @monster.magic_resistance).to_i
    end
    [ session[:monster_health] -= damage, 0 ].max
    message = "You cast #{spell[:name]} on #{@monster.name} for #{damage} #{spell.damage_type} damage!"
    message.prepend("CRITICAL STRIKE! ") if has_crit
    session[:messages] << message
    trim_messages
  end

  def monster_attack
    damage = [ (rand(@monster.min_physical_damage..@monster.max_physical_damage) - @character.armor), 0 ].max
    @character.update(health: [ @character.health - damage, 0 ].max)
    session[:messages] << "#{@monster.name} attacks you for #{damage} damage!"
    trim_messages
  end

  def handle_battle_outcomes
    if session[:monster_health] <= 0
      xp_gain = (@character.max_experience * 0.10).to_i
      @character.level_up
      @result = "Victory! You defeated the #{@monster.name}!"
      @character.update(experience: @character.experience + xp_gain)
      @character.update(dungeon_stage: @character.dungeon_stage + 1)
      session[:turn] = nil
      return true
    elsif @character.health <= 0
      @result = "You were defeated by the #{@monster.name}!"
      session[:turn] = nil
      return true
    end
    false
  end

  def trim_messages
    session[:messages] = session[:messages]
  end

  def toggle_turn
    session[:turn] = session[:turn] == "character" ? "monster" : "character"
  end
end
