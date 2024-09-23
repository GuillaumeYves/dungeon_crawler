class CreateSpells < ActiveRecord::Migration[7.2]
  def change
    create_table :spells do |t|
      t.string :name
      t.string :class_required
      t.boolean :unlocked, default: false
      t.string :spell_type
      t.bigint :mana_cost
      t.bigint :level_required
      t.bigint :cooldown
      t.bigint :damage
      t.string :damage_type
      t.string :effect

      t.timestamps
    end
  end
end
