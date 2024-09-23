Spell.create([
  # Base spells
  { unlocked: true, name: "Heavy Strike", class_required: "warrior", spell_type: "attack", base_cooldown: 4, cooldown: 0, mana_cost: 25, damage: 10, damage_type: "physical" },
  { unlocked: true, name: "Fireball", class_required: "mage", spell_type: "fire", base_cooldown: 2, cooldown: 0, mana_cost: 40, damage: 20, damage_type: "magic" },
  { unlocked: true, name: "Backstab", class_required: "rogue", spell_type: "attack", base_cooldown: 1, cooldown: 0, mana_cost: 10, damage: 5, damage_type: "physical" },
  # Warrior spells
  { unlocked: true, name: "Frenzy", class_required: "warrior", spell_type: "attack", base_cooldown: 0, cooldown: 0, mana_cost: 10, damage: 5, damage_type: "physical" }
])
