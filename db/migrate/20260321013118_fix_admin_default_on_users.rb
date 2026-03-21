# frozen_string_literal: true

class FixAdminDefaultOnUsers < ActiveRecord::Migration[7.1]
  def change
    change_table(:users, bulk: true) do |t|
      t.change_default(:admin, from: nil, to: false)
      t.change_null(:admin, false)
    end
  end
end
