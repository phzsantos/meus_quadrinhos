# frozen_string_literal: true

namespace :import do
  desc "Import authors from json file"
  task authors: :environment do
    show_spinner("Importing authors...") { import_authors }
  end

  def import_authors
    authors = JSON.parse(File.read(Rails.root.join("db/seeds/authors.json")))
    authors.each do |name|
      Author.find_or_create_by!(name:)
    end
  end
end
