class AddCharacterIdToSpells < ActiveRecord::Migration[7.2]
  def change
    add_column :spells, :character_id, :integer
  end
end
