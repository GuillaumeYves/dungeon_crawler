class AddRanksToSpells < ActiveRecord::Migration[7.2]
  def change
    add_column :spells, :spell_rank, :string
  end
end
