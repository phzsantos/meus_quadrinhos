# frozen_string_literal: true

class CreateUserComics < ActiveRecord::Migration[7.1]
  def change
    create_table(:user_comics, id: :uuid) do |t|
      t.references(:user, null: false, foreign_key: true, type: :uuid)
      t.references(:comic, null: false, foreign_key: true, type: :uuid)

      t.timestamps
    end

    add_index(:user_comics, [:user_id, :comic_id], unique: true)
  end
end
