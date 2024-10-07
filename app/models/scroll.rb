class Scroll < ApplicationRecord
  belongs_to :spell
  belongs_to :character_inventory, optional: true
end
