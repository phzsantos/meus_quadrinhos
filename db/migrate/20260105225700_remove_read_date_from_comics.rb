# frozen_string_literal: true

class RemoveReadDateFromComics < ActiveRecord::Migration[7.1]
  def change
    remove_column(:comics, :read_date, :date)
  end
end
