# frozen_string_literal: true

class AddSlugToBookBindings < ActiveRecord::Migration[7.1]
  def change
    add_column(:book_bindings, :slug, :string)
    add_index(:book_bindings, :slug, unique: true)
  end
end
