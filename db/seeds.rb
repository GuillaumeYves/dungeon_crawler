Spell.create([
  # Base spells
  { unlocked: true, name: "Heavy Strike", spell_rank: "novice", class_required: "warrior", spell_type: "attack",
  base_cooldown: 2, cooldown: 0, mana_cost: 20, damage: 10, damage_type: "physical",
  description: "Attack the target with a mighty blow." },

  { unlocked: true, name: "Fireball", spell_rank: "novice", class_required: "mage", spell_type: "fire",
  base_cooldown: 4, cooldown: 0, mana_cost: 40, damage: 20, damage_type: "magic",
  description: "Unleash a ball of fire at your target." },

  { unlocked: true, name: "Backstab", spell_rank: "novice", class_required: "rogue", spell_type: "attack",
  base_cooldown: 1, cooldown: 0, mana_cost: 10, damage: 5, damage_type: "physical",
  description: "A stealthy attack that catches foes off guard." },

  # Warrior spells
  { unlocked: true, name: "Frenzy", class_required: "warrior", spell_type: "attack",
  base_cooldown: 0, cooldown: 0, mana_cost: 15, damage: 5, damage_type: "physical",
  description: "Strike the target furiously. Each consecutive use increases the damage of Frenzy stacking up to 5 times." },

  # Mage spells
  { unlocked: true, name: "Fireblast", class_required: "mage", spell_type: "fire",
  base_cooldown: 8, cooldown: 0, mana_cost: 80, damage: 40, damage_type: "magic",
  description: "Incinerate the target with a powerful explosion of flames."  },

  # Rogue spells
  { unlocked: true, name: "Ambush", class_required: "rogue", spell_type: "attack",
  base_cooldown: 3, cooldown: 0, mana_cost: 30, damage: 15, damage_type: "physical",
  description: "Overwhelm the target before they can react. Deal increased damage to targets above 80% health." }
])

Scroll.create([
  { name: 'Scroll of Frenzy', spell: Spell.find_by(name: 'Frenzy'), level_required: 2, class_required: "warrior" }
])
