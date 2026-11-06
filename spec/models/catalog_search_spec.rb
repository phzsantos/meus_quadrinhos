# frozen_string_literal: true

require "rails_helper"

RSpec.describe(CatalogSearch) do
  describe ".filter" do
    it "matches ignoring accents, case, and punctuation" do
      comic = create(:comic, title: "Mônica, a princesa")
      create(:comic, title: "Batman")

      results = described_class.filter(Comic.all, "monica princesa", Comic.arel_table[:title])

      expect(results).to(contain_exactly(comic))
    end

    it "requires every word to match" do
      create(:comic, title: "Alan Moore")
      alan = create(:comic, title: "Alan Davis")

      results = described_class.filter(Comic.all, "alan davis", Comic.arel_table[:title])

      expect(results).to(contain_exactly(alan))
    end

    it "returns the original relation when the query is blank" do
      comic = create(:comic)

      expect(described_class.filter(Comic.all, "  ", Comic.arel_table[:title])).to(contain_exactly(comic))
    end

    it "returns the original relation when the query is nil" do
      comic = create(:comic)

      expect(described_class.filter(Comic.all, nil, Comic.arel_table[:title])).to(contain_exactly(comic))
    end
  end

  describe "Comic.matching_query" do
    it "matches title, issue number, and issue title" do
      comic = create(:comic, title: "Sandman", issue_number: 12, issue_title: "O sonho")
      create(:comic, title: "Sandman", issue_number: 8, issue_title: "Outro")

      expect(Comic.matching_query("sonho")).to(contain_exactly(comic))
      expect(Comic.matching_query("sandman 12")).to(contain_exactly(comic))
      expect(Comic.matching_query("12")).to(contain_exactly(comic))
    end
  end

  describe "Collection.matching_query" do
    it "matches the collection name" do
      collection = create(:collection, name: "Saga do Batman")
      create(:collection, name: "Absolute Sandman")

      expect(Collection.matching_query("saga")).to(contain_exactly(collection))
    end
  end

  describe "Author.matching_query" do
    it "matches the author name" do
      author = create(:author, name: "Will Eisner")
      create(:author, name: "Frank Miller")

      expect(Author.matching_query("eisner")).to(contain_exactly(author))
    end
  end

  describe "Character.matching_query" do
    it "matches the character name" do
      character = create(:character, name: "Batman")
      create(:character, name: "Superman")

      expect(Character.matching_query("batman")).to(contain_exactly(character))
    end
  end

  describe "Publisher.matching_query" do
    it "matches the publisher name" do
      publisher = create(:publisher, name: "DC Comics")
      create(:publisher, name: "Marvel Comics")

      expect(Publisher.matching_query("dc")).to(contain_exactly(publisher))
    end
  end

  describe "BookBinding.matching_query" do
    it "matches the book binding name" do
      book_binding = create(:book_binding, name: "Capa dura")
      create(:book_binding, name: "Brochura")

      expect(BookBinding.matching_query("capa")).to(contain_exactly(book_binding))
    end
  end

  describe "PaperType.matching_query" do
    it "matches the paper type name" do
      paper_type = create(:paper_type, name: "Couchê")
      create(:paper_type, name: "Offset")

      expect(PaperType.matching_query("couche")).to(contain_exactly(paper_type))
    end
  end

  describe "PublicationType.matching_query" do
    it "matches the publication type name" do
      publication_type = create(:publication_type, name: "HQ")
      create(:publication_type, name: "Mangá")

      expect(PublicationType.matching_query("hq")).to(contain_exactly(publication_type))
    end
  end
end
