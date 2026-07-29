# frozen_string_literal: true

namespace :import do
  desc "Import paper types from json file"
  task paper_types: :environment do
    show_spinner("Importing paper types...") { import_paper_types }
  end

  def import_paper_types
    paper_types = JSON.parse(File.read(Rails.root.join("db/seeds/paper_types.json")))
    paper_types.each do |name|
      PaperType.find_or_create_by!(name:)
    end
  end
end
