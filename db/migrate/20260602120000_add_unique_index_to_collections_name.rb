# frozen_string_literal: true

class AddUniqueIndexToCollectionsName < ActiveRecord::Migration[7.1]
  def change
    add_index(:collections, :name, unique: true)
  end
end
