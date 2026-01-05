# frozen_string_literal: true

class AddStoryCountToComics < ActiveRecord::Migration[7.1]
  def change
    add_column(:comics, :story_count, :integer)
  end
end
