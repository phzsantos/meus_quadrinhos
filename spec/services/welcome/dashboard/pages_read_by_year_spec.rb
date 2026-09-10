# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::PagesReadByYear) do
  let(:user) { create(:user) }

  subject(:context) { described_class.call(user: user) }

  describe ".call" do
    context "when there are readings in different years" do
      let!(:comic_2022_a) { create(:comic, page_count: 100) }
      let!(:comic_2022_b) { create(:comic, page_count: 150) }
      let!(:comic_2023)   { create(:comic, page_count: 200) }

      before do
        create(:reading, user: user, comic: comic_2022_a, read_at: Date.new(2022, 3, 10))
        create(:reading, user: user, comic: comic_2022_b, read_at: Date.new(2022, 7, 5))
        create(:reading, user: user, comic: comic_2023,   read_at: Date.new(2023, 1, 20))
      end

      it "returns years with readings in ascending order" do
        expect(context.pages_read_years).to(eq([2022, 2023]))
      end

      it "returns page counts per year respecting year order" do
        expect(context.pages_read_count_by_year).to(eq([250, 200]))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when there are no readings" do
      it "returns an empty list of years with readings" do
        expect(context.pages_read_years).to(eq([]))
      end

      it "returns an empty list of page counts per year" do
        expect(context.pages_read_count_by_year).to(eq([]))
      end
    end
  end
end
