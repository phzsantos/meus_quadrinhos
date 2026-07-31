# frozen_string_literal: true

namespace :import do
  desc "Import publishers from json file"
  task publishers: :environment do
    show_spinner("Importing publishers...") { import_publishers }
  end

  def import_publishers
    publishers = JSON.parse(File.read(Rails.root.join("db/seeds/publishers.json")))
    publishers.each do |name|
      Publisher.find_or_create_by!(name:)
    end
  end
end
