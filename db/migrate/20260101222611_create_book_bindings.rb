# frozen_string_literal: true

class CreateBookBindings < ActiveRecord::Migration[7.1]
  def change
    create_table(:book_bindings, id: :uuid) do |t|
      t.string(:name, null: false)

      t.timestamps
    end
  end
end
