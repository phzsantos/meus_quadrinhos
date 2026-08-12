# frozen_string_literal: true

namespace :export do
  desc "Export paper types to json file"
  task paper_types: :environment do
    show_spinner("Exporting paper types...") do
      export_via_controller(PaperTypesController, "paper_types.json")
    end
  end
end
