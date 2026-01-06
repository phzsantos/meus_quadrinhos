# frozen_string_literal: true

class AddCollectionToComics < ActiveRecord::Migration[7.1]
  def change
    add_reference(:comics, :collection, foreign_key: true, type: :uuid)
  end
end
