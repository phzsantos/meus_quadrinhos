# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Comic, type: :model) do
  subject(:comic) { build(:comic) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:title)) }
    it { is_expected.to(validate_presence_of(:page_count)) }
    it { is_expected.to(validate_presence_of(:published_year)) }
    it { is_expected.to(validate_presence_of(:story_count)) }
    it { is_expected.to(validate_presence_of(:authors)) }
    it { is_expected.to(validate_presence_of(:characters)) }
    it { is_expected.to(validate_presence_of(:issue_number)) }

    it do
      is_expected.to(validate_uniqueness_of(:title)
        .scoped_to(:issue_number)
        .case_insensitive
        .with_message(:duplicated_comic))
    end

    it do
      is_expected.to(validate_numericality_of(:page_count)
        .is_greater_than(0))
    end

    it do
      is_expected.to(validate_numericality_of(:published_year)
        .only_integer)
    end

    it do
      is_expected.to(validate_numericality_of(:story_count)
        .only_integer
        .is_greater_than(0))
    end

    it do
      is_expected.to(validate_numericality_of(:issue_number)
        .only_integer)
    end
  end

  describe "associations" do
    it { is_expected.to(belong_to(:publisher)) }
    it { is_expected.to(belong_to(:publication_type)) }
    it { is_expected.to(belong_to(:book_binding)) }
    it { is_expected.to(belong_to(:paper_type)) }
    it { is_expected.to(belong_to(:collection).optional) }

    it { is_expected.to(have_many(:comic_authors).dependent(:destroy)) }
    it { is_expected.to(have_many(:authors).through(:comic_authors)) }

    it { is_expected.to(have_many(:comic_characters).dependent(:destroy)) }
    it { is_expected.to(have_many(:characters).through(:comic_characters)) }

    it { is_expected.to(have_many(:readings).dependent(:destroy)) }
  end

  describe "friendly_id" do
    it "generates slug from title" do
      comic = create(:comic, title: "Watchmen", collection: nil)

      expect(comic.slug).to(eq("watchmen"))
    end

    it "updates slug when title changes" do
      comic = create(:comic, title: "Watchmen", collection: nil)

      comic.update!(title: "V for Vendetta")

      expect(comic.slug).to(eq("v-for-vendetta"))
    end
  end

  describe "callbacks" do
    it "removes blank ids before validation" do
      author = create(:author)

      comic = build(:comic)
      comic.author_ids = ["", author.id]

      comic.valid?

      expect(comic.author_ids).to(eq([author.id]))
    end
  end

  describe "readings nested attributes" do
    it "ignores blank reading" do
      comic = create(:comic)

      comic.update(
        readings_attributes: [
          { read_at: nil },
        ],
      )

      expect(comic.readings.count).to(eq(0))
    end

    it "removes reading when _destroy is 1" do
      comic = create(:comic)
      reading = create(:reading, comic: comic)

      comic.update(
        readings_attributes: [
          { id: reading.id, _destroy: "1" },
        ],
      )

      expect(comic.readings.reload).to(be_empty)
    end
  end
end
