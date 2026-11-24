# frozen_string_literal: true

class AddIndexToReadingsOnUserIdAndReadAt < ActiveRecord::Migration[7.1]
  def change
    add_index(:readings, [:user_id, :read_at])
  end
end
