# frozen_string_literal: true

namespace :export do
  desc "Export publication types to json file"
  task publication_types: :environment do
    show_spinner("Exporting publication types...") do
      export_via_controller(PublicationTypesController, "publication_types.json")
    end
  end
end
