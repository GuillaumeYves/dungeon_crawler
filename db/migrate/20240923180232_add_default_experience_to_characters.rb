class AddDefaultExperienceToCharacters < ActiveRecord::Migration[7.2]
  def change
    change_column_default :characters, :experience, 0
  end
end
