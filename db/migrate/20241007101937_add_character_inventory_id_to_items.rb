class AddCharacterInventoryIdToItems < ActiveRecord::Migration[7.2]
  def change
    add_reference :items, :character_inventory, null: false, foreign_key: true
  end
end
