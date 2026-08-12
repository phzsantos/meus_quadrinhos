# frozen_string_literal: true

namespace :export do
  desc "Export characters to json file"
  task characters: :environment do
    show_spinner("Exporting characters...") do
      export_via_controller(CharactersController, "characters.json")
    end
  end
end
