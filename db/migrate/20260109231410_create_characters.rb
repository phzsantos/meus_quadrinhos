# frozen_string_literal: true

class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table(:characters, id: :uuid) do |t|
      t.string(:name)

      t.timestamps
    end
  end
end
