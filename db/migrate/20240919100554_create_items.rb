class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :slot_type
      t.string :item_type

      t.bigint :health
      t.bigint :min_physical_damage
      t.bigint :max_physical_damage
      t.bigint :min_magic_damage
      t.bigint :max_magic_damage
      t.bigint :armor
      t.bigint :magic_resistance

      t.decimal :dodge_chance, precision: 5, scale: 2
      t.decimal :critical_strike_chance, precision: 5, scale: 2
      t.decimal :critical_strike_damage, precision: 5, scale: 2

      t.timestamps
    end
  end
end
