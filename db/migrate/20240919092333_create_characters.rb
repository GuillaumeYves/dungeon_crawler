class CreateCharacters < ActiveRecord::Migration[7.2]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :character_class
      t.bigint :gold, default: 0

      t.bigint :health, default: 100
      t.bigint :max_health, default: 100
      t.bigint :min_physical_damage, default: 5
      t.bigint :max_physical_damage, default: 10
      t.bigint :min_magic_damage, default: 5
      t.bigint :max_magic_damage, default: 10
      t.bigint :armor, default: 5
      t.bigint :magic_resistance, default: 5

      t.decimal :dodge_chance, precision: 5, scale: 2, default: 0.02
      t.decimal :critical_strike_chance, precision: 5, scale: 2, default: 0.05
      t.decimal :critical_strike_damage, precision: 5, scale: 2, default: 1.50

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
