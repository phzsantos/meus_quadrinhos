# frozen_string_literal: true

class CreateComicCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table(:comic_characters, id: :uuid) do |t|
      t.references(:comic, null: false, foreign_key: true, type: :uuid)
      t.references(:character, null: false, foreign_key: true, type: :uuid)

      t.timestamps
    end
  end
end
