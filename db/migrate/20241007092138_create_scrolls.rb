class CreateScrolls < ActiveRecord::Migration[7.2]
  def change
    create_table :scrolls do |t|
      t.string :name
      t.references :spell, null: false, foreign_key: true
      t.bigint :level_required
      t.string :description
      t.string :class_required
      t.timestamps
    end
  end
end
