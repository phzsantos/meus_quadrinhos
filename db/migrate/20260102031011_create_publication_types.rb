# frozen_string_literal: true

class CreatePublicationTypes < ActiveRecord::Migration[7.1]
  def change
    create_table(:publication_types, id: :uuid) do |t|
      t.string(:name, null: false)

      t.timestamps
    end
  end
end
