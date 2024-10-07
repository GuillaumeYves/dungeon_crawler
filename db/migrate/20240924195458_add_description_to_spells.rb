class AddDescriptionToSpells < ActiveRecord::Migration[7.2]
  def change
    add_column :spells, :description, :string
  end
end
