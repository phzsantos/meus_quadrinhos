# frozen_string_literal: true

class AddUserIdToReadings < ActiveRecord::Migration[7.1]
  class MigrationUser < ApplicationRecord
    self.table_name = "users"
  end

  class MigrationComic < ApplicationRecord
    self.table_name = "comics"
  end

  class MigrationReading < ApplicationRecord
    self.table_name = "readings"
  end

  class MigrationUserComic < ApplicationRecord
    self.table_name = "user_comics"
  end

  def up
    add_reference(:readings, :user, null: true, foreign_key: true, type: :uuid)

    admin = MigrationUser.find_by(admin: true) || MigrationUser.order(:created_at).first

    if admin
      MigrationReading.where(user_id: nil).find_each do |reading|
        reading.update!(user_id: admin.id)
      end

      MigrationComic.find_each do |comic|
        MigrationUserComic.find_or_create_by!(user_id: admin.id, comic_id: comic.id)
      end
    elsif MigrationReading.exists?
      raise ActiveRecord::IrreversibleMigration,
        "Cannot require readings.user_id without an existing user to own current readings"
    end

    change_column_null(:readings, :user_id, false)
  end

  def down
    remove_reference(:readings, :user, foreign_key: true)
  end
end
