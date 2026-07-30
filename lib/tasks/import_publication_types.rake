# frozen_string_literal: true

namespace :import do
  desc "Import publication types from json file"
  task publication_types: :environment do
    show_spinner("Importing publication types...") { import_publication_types }
  end

  def import_publication_types
    publication_types = JSON.parse(File.read(Rails.root.join("db/seeds/publication_types.json")))
    publication_types.each do |name|
      PublicationType.find_or_create_by!(name:)
    end
  end
end
