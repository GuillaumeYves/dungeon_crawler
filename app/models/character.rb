class Character < ApplicationRecord
  belongs_to :user
  before_validation :set_default_stats, if: :new_record?

  validates :name, presence: true

  # Equipment slots
  has_one :main_hand, class_name: "Item"
  has_one :off_hand, class_name: "Item"
  has_one :head, class_name: "Item"
  has_one :chest, class_name: "Item"
  has_one :legs, class_name: "Item"
  has_one :feet, class_name: "Item"

  has_many :spells, dependent: :destroy

  attr_accessor :frenzy_stacks, :frenzy_damage

  CLASS_STATS = {
    "warrior" => { health: 100, max_health: 100, min_physical_damage: 17, max_physical_damage: 22, min_magic_damage: 13,
    max_magic_damage: 18, armor: 8, magic_resistance: 2, dodge_chance: 0.01, critical_strike_chance: 0.05,
    critical_strike_damage: 1.5 },
    "mage" => { health: 80, max_health: 80, min_physical_damage: 11, max_physical_damage: 16, min_magic_damage: 24,
    max_magic_damage: 29, armor: 1, magic_resistance: 9, dodge_chance: 0.02, critical_strike_chance: 0.02,
    critical_strike_damage: 1.2 },
    "rogue" => { health: 90, max_health: 90, min_physical_damage: 13, max_physical_damage: 18, min_magic_damage: 13,
    max_magic_damage: 18, armor: 2, magic_resistance: 2, dodge_chance: 0.10, critical_strike_chance: 0.08,
    critical_strike_damage: 1.8 }
  }.freeze

  def level_up
    while self.experience >= self.max_experience
      self.level += 1
      self.skill_points += 1
      overflow_experience = self.experience - self.max_experience
      self.max_experience = (self.max_experience * 1.22).to_i
      self.experience = overflow_experience
    end
    self.save
  end

  def gain_experience(xp_gain)
    self.experience += xp_gain
    while self.experience >= self.max_experience
      self.level_up
    end

    self.save
  end

  def set_default_stats
    stats = CLASS_STATS[character_class] || CLASS_STATS["warrior"]
    self.health = stats[:health]
    self.max_health = stats[:max_health]
    self.min_physical_damage = stats[:min_physical_damage]
    self.max_physical_damage = stats[:max_physical_damage]
    self.min_magic_damage = stats[:min_magic_damage]
    self.max_magic_damage = stats[:max_magic_damage]
    self.armor = stats[:armor]
    self.magic_resistance = stats[:magic_resistance]
    self.dodge_chance = stats[:dodge_chance]
    self.critical_strike_chance = stats[:critical_strike_chance]
    self.critical_strike_damage = stats[:critical_strike_damage]
  end

  def assign_spells_based_on_class
    base_spells = Spell.where(class_required: self.character_class)

    self.spells = base_spells.map do |spell|
      duplicated_spell = spell.dup
      duplicated_spell.character_id = self.id
      duplicated_spell.save
    end
  end

  def cannot_cast?(spell)
    !spell.unlocked || on_cooldown?(spell) || (self.mana < spell.mana_cost)
  end

  def on_cooldown?(spell)
    spell.cooldown > 0
  end

  def turn_start_reduce_cooldowns
    self.spells.where(unlocked: true).each do |spell|
      if spell.cooldown > 0
        spell.update(cooldown: spell.cooldown - 1)
      end
    end
  end

  def equip(item, slot)
    return unless EQUIPMENT_SLOTS.include?(slot)
    previous_item = send(slot)
    if previous_item
      remove_item_stats(previous_item)
    end
    send("#{slot}=", item)
    apply_item_stats(item)
  end

  def unequip(slot)
    return unless EQUIPMENT_SLOTS.include?(slot)
    item = send(slot)
    if item
      remove_item_stats(item)
      send("#{slot}=", nil)
      save
    end
  end

  def apply_item_stats(item)
    self.health += item.health.to_i if item.health.present?
    self.max_health += item.health.to_i if item.health.present?
    self.min_physical_damage += item.min_physical_damage.to_i if item.min_physical_damage.present?
    self.max_physical_damage += item.max_physical_damage.to_i if item.max_physical_damage.present?
    self.min_magic_damage += item.min_magic_damage.to_i if item.min_magic_damage.present?
    self.max_magic_damage += item.max_magic_damage.to_i if item.max_magic_damage.present?
    self.armor += item.armor_modifier.to_i if item.armor.present?
    self.magic_resistance += item.magic_resistance.to_i if item.magic_resistance.present?
    self.dodge_chance += item.dodge_chance.to_d if item.dodge_chance.present?
    self.critical_strike_chance += item.critical_strike_chance.to_d if item.critical_strike_chance.present?
    self.critical_strike_damage += item.critical_strike_damage.to_d if item.critical_strike_damage.present?

    save
  end

  def remove_item_stats(item)
    if item
      self.health -= item.health.to_i if item.health.present?
      self.max_health -= item.health.to_i if item.health.present?
      self.min_physical_damage -= item.min_physical_damage.to_i if item.min_physical_damage.present?
      self.max_physical_damage -= item.max_physical_damage.to_i if item.max_physical_damage.present?
      self.min_magic_damage -= item.min_magic_damage.to_i if item.min_magic_damage.present?
      self.max_magic_damage -= item.max_magic_damage.to_i if item.max_magic_damage.present?
      self.armor -= item.armor_modifier.to_i if item.armor_modifier.present?
      self.magic_resistance -= item.magic_resistance.to_i if item.magic_resistance.present?
      self.dodge_chance -= item.dodge_chance.to_d if item.dodge_chance.present?
      self.critical_strike_chance -= item.critical_strike_chance.to_d if item.critical_strike_chance.present?
      self.critical_strike_damage -= item.critical_strike_damage.to_d if item.critical_strike_damage.present?

      save
    end
  end

  private

  EQUIPMENT_SLOTS = %w[main_hand off_hand head chest legs feet].freeze

  def item_fits_slot?(item, slot)
    case slot
    when "main_hand", "off_hand"
      item.item_type.in?(%w[one_handed two_handed shield])
    when "head", "chest", "legs", "feet"
      item.item_type == slot
    else
      false
    end
  end

  def equipped_items
    [ main_hand, off_hand, head, chest, legs, feet ].compact
  end
end
