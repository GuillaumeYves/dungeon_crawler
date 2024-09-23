class AddEquipmentSlotsToCharacters < ActiveRecord::Migration[7.2]
  def change
    add_reference :characters, :main_hand, foreign_key: { to_table: :items }, null: true
    add_reference :characters, :off_hand, foreign_key: { to_table: :items }, null: true
    add_reference :characters, :head, foreign_key: { to_table: :items }, null: true
    add_reference :characters, :chest, foreign_key: { to_table: :items }, null: true
    add_reference :characters, :legs, foreign_key: { to_table: :items }, null: true
    add_reference :characters, :feet, foreign_key: { to_table: :items }, null: true
  end
end
