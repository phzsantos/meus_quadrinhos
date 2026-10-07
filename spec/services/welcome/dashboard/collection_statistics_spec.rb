# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::CollectionStatistics) do
  let(:user) { create(:user) }

  subject(:context) { described_class.call(user: user) }

  describe ".call" do
    context "when the user owns comics" do
      let!(:read_comic) { create(:comic, page_count: 100, story_count: 2) }
      let!(:unread_comic) { create(:comic, page_count: 200, story_count: 3) }
      let!(:other_comic) { create(:comic, page_count: 50, story_count: 1) }

      before do
        create(:user_comic, user: user, comic: read_comic)
        create(:user_comic, user: user, comic: unread_comic)
        create(:reading, user: user, comic: read_comic, read_at: Time.current)
      end

      it "returns the total number of owned comics" do
        expect(context.total_collection_comics).to(eq(2))
      end

      it "returns the number of owned comics that were not read" do
        expect(context.total_unread_comics).to(eq(1))
      end

      it "returns the total number of pages in the collection" do
        expect(context.total_collection_pages).to(eq(300))
      end

      it "returns the total number of stories in the collection" do
        expect(context.total_collection_stories).to(eq(5))
      end

      it "ignores comics that are not in the collection" do
        expect(user.owned_comics).not_to(include(other_comic))
        expect(context.total_collection_comics).to(eq(2))
      end

      it "executes the flow successfully" do
        expect(context).to(be_success)
      end
    end

    context "when another user owns comics" do
      let(:other_user) { create(:user) }
      let!(:owned_comic) { create(:comic, page_count: 80, story_count: 1) }
      let!(:other_owned_comic) { create(:comic, page_count: 40, story_count: 4) }

      before do
        create(:user_comic, user: user, comic: owned_comic)
        create(:user_comic, user: other_user, comic: other_owned_comic)
      end

      it "counts only the current user's collection" do
        expect(context.total_collection_comics).to(eq(1))
        expect(context.total_unread_comics).to(eq(1))
        expect(context.total_collection_pages).to(eq(80))
        expect(context.total_collection_stories).to(eq(1))
      end
    end

    context "when an owned comic was read by another user" do
      let(:other_user) { create(:user) }
      let!(:comic) { create(:comic) }

      before do
        create(:user_comic, user: user, comic: comic)
        create(:reading, user: other_user, comic: comic, read_at: Time.current)
      end

      it "still counts the comic as unread for the current user" do
        expect(context.total_unread_comics).to(eq(1))
      end
    end

    context "when the collection is empty" do
      it "returns 0 for every total" do
        expect(context.total_collection_comics).to(eq(0))
        expect(context.total_unread_comics).to(eq(0))
        expect(context.total_collection_pages).to(eq(0))
        expect(context.total_collection_stories).to(eq(0))
      end
    end
  end
end
