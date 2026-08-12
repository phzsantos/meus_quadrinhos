# frozen_string_literal: true

namespace :export do
  desc "Export collections to json file"
  task collections: :environment do
    show_spinner("Exporting collections...") do
      export_via_controller(CollectionsController, "collections.json")
    end
  end
end
