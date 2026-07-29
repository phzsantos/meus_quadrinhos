# frozen_string_literal: true

namespace :utils do
  desc "Recreate environment"
  task recreate_environment: :environment do
    show_spinner("Dropping database...") { quiet_system("rails db:drop") }
    show_spinner("Creating database...") { quiet_system("rails db:create") }
    show_spinner("Migrating database...") { quiet_system("rails db:migrate") }
    system("rails import:authors")
    system("rails import:book_bindings")
    system("rails import:characters")
    system("rails import:collections")
    system("rails import:paper_types")
    show_spinner("Seeding database...") { quiet_system("rails db:seed") }
  end
end
