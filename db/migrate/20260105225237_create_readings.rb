# frozen_string_literal: true

class CreateReadings < ActiveRecord::Migration[7.1]
  def change
    create_table(:readings, id: :uuid) do |t|
      t.references(:comic, null: false, foreign_key: true, type: :uuid)
      t.date(:read_at)

      t.timestamps
    end
  end
end
