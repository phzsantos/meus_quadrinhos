# frozen_string_literal: true

namespace :export do
  desc "Export authors to json file"
  task authors: :environment do
    show_spinner("Exporting authors...") do
      export_via_controller(AuthorsController, "authors.json")
    end
  end
end
