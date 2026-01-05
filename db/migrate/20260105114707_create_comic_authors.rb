# frozen_string_literal: true

class CreateComicAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table(:comic_authors, id: :uuid) do |t|
      t.references(:comic, null: false, foreign_key: true, type: :uuid)
      t.references(:author, null: false, foreign_key: true, type: :uuid)

      t.timestamps
    end
  end
end
