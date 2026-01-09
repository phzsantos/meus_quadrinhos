# frozen_string_literal: true

class AddSlugToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column(:characters, :slug, :string)
    add_index(:characters, :slug, unique: true)
  end
end
