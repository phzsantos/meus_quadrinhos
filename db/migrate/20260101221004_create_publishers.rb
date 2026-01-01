# frozen_string_literal: true

class CreatePublishers < ActiveRecord::Migration[7.1]
  def change
    create_table(:publishers, id: :uuid) do |t|
      t.string(:name, null: false)

      t.timestamps
    end
  end
end
