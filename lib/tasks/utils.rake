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
    system("rails import:publication_types")
    system("rails import:publishers")
    system("rails import:comics")
    show_spinner("Seeding database...") { quiet_system("rails db:seed") }
  end

  desc "Backup data to seed files"
  task backup: :environment do
    system("rails export:authors")
    system("rails export:book_bindings")
    system("rails export:characters")
    system("rails export:collections")
    system("rails export:paper_types")
    system("rails export:publication_types")
    system("rails export:publishers")
    system("rails export:comics")
  end
end
