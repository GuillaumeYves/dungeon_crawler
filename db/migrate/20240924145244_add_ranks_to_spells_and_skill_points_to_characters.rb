class AddRanksToSpellsAndSkillPointsToCharacters < ActiveRecord::Migration[7.2]
  def change
    add_column :spells, :rank, :integer, default: 1
    add_column :characters, :skill_points, :integer, default: 0
    add_column :characters, :spell_id, :integer
  end
end
