# frozen_string_literal: true

namespace :import do
  desc "Import collections from json file"
  task collections: :environment do
    show_spinner("Importing collections...") { import_collections }
  end

  def import_collections
    collections = JSON.parse(File.read(Rails.root.join("db/seeds/collections.json")))
    collections.each do |collection|
      Collection.find_or_create_by!(
        name: collection["name"],
        link_guia_dos_quadrinhos: collection["link_guia_dos_quadrinhos"],
      )
    end
  end
end
