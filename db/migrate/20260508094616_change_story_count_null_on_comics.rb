# frozen_string_literal: true

class ChangeStoryCountNullOnComics < ActiveRecord::Migration[7.1]
  def change
    change_column_null(:comics, :story_count, false)
  end
end
