class AddBaseCooldownToSpells < ActiveRecord::Migration[7.2]
  def change
    add_column :spells, :base_cooldown, :integer
  end
end
