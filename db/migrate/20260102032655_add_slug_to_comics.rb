# frozen_string_literal: true

class AddSlugToComics < ActiveRecord::Migration[7.1]
  def change
    add_column(:comics, :slug, :string)
    add_index(:comics, :slug, unique: true)
  end
end
