class Item < ApplicationRecord
  belongs_to :character_inventory, optional: true
end
