class CreateMonsters < ActiveRecord::Migration[7.2]
  def change
    create_table :monsters do |t|
      t.string :name

      t.bigint :health
      t.bigint :max_health
      t.bigint :min_physical_damage
      t.bigint :max_physical_damage
      t.bigint :min_magic_damage
      t.bigint :max_magic_damage
      t.bigint :armor
      t.bigint :magic_resistance

      t.decimal :dodge_chance, precision: 5, scale: 2, default: 0.02
      t.decimal :critical_strike_chance, precision: 5, scale: 2, default: 0.05
      t.decimal :critical_strike_damage, precision: 5, scale: 2, default: 1.50

      t.timestamps
    end
  end
end
