# frozen_string_literal: true

class CreateComics < ActiveRecord::Migration[7.1]
  def change
    create_table(:comics, id: :uuid) do |t|
      t.string(:title, null: false)
      t.integer(:page_count, null: false)
      t.integer(:published_year, null: false)
      t.references(:author, null: false, foreign_key: true, type: :uuid)
      t.references(:publisher, null: false, foreign_key: true, type: :uuid)
      t.references(:publication_type, null: false, foreign_key: true, type: :uuid)
      t.references(:book_binding, null: false, foreign_key: true, type: :uuid)
      t.references(:paper_type, null: false, foreign_key: true, type: :uuid)

      t.timestamps
    end
  end
end
