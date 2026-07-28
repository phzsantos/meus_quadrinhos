# frozen_string_literal: true

namespace :import do
  desc "Import characters from json file"
  task characters: :environment do
    show_spinner("Importing characters...") { import_characters }
  end

  def import_characters
    characters = JSON.parse(File.read(Rails.root.join("db/seeds/characters.json")))
    characters.each do |name|
      Character.find_or_create_by!(name:)
    end
  end
end
