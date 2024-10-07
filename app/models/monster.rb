class Monster < ApplicationRecord
  MONSTER_NAMES = [
    "Vampire",
    "Werewolf",
    "Skeleton",
    "Zombie",
    "Ghoul",
    "Mummy",
    "Banshee",
    "Golem",
    "Wraith",
    "Demon"
  ].freeze

  def drop_item_or_scroll(character)
    loot = []

    # Drop logic for items (adjust as necessary)
    if rand < 0.25
      item = Item.order("RANDOM()").first
      loot << item
    end

    # Drop logic for scrolls
    if rand <= 1
      eligible_scrolls = Scroll.joins(:spell).where(spells: { class_required: character.character_class })
      if eligible_scrolls.any?
        selected_scroll = eligible_scrolls.sample
        loot << selected_scroll
      end
    end

    loot
  end
end
