class AddManaLevelsToCharacters < ActiveRecord::Migration[7.2]
  def change
    add_column :characters, :mana, :bigint, default: 100
    add_column :characters, :max_mana, :bigint, default: 100
    add_column :characters, :level, :bigint, default: 1
  end
end
