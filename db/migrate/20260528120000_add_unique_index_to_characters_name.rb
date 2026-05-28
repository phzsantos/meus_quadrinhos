# frozen_string_literal: true

class AddUniqueIndexToCharactersName < ActiveRecord::Migration[7.1]
  def change
    add_index(:characters, :name, unique: true)
  end
end
