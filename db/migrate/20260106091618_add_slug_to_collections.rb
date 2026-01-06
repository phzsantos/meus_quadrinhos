# frozen_string_literal: true

class AddSlugToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column(:collections, :slug, :string)
    add_index(:collections, :slug, unique: true)
  end
end
