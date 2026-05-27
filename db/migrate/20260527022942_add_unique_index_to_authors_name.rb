# frozen_string_literal: true

class AddUniqueIndexToAuthorsName < ActiveRecord::Migration[7.1]
  def change
    add_index(:authors, :name, unique: true)
  end
end
