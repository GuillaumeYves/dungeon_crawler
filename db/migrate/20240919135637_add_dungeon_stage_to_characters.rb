class AddDungeonStageToCharacters < ActiveRecord::Migration[7.2]
  def change
    add_column :characters, :dungeon_stage, :bigint, default: 1
    add_column :characters, :experience, :bigint
    add_column :characters, :max_experience, :bigint, default: 100
  end
end
