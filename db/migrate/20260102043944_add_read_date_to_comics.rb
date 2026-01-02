# frozen_string_literal: true

class AddReadDateToComics < ActiveRecord::Migration[7.1]
  def change
    add_column(:comics, :read_date, :date)
  end
end
