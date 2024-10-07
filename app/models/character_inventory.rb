class CharacterInventory < ApplicationRecord
  belongs_to :character
  has_many :items, dependent: :destroy
  has_many :scrolls, dependent: :destroy
end
