# frozen_string_literal: true

class AddUniqueIndexToCatalogNames < ActiveRecord::Migration[7.1]
  def change
    add_index(:publishers, :name, unique: true)
    add_index(:paper_types, :name, unique: true)
    add_index(:book_bindings, :name, unique: true)
    add_index(:publication_types, :name, unique: true)
  end
end
