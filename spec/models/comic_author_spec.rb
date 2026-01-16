# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ComicAuthor, type: :model) do
  subject(:comic_author) { build(:comic_author) }

  describe "associations" do
    it { is_expected.to(belong_to(:comic)) }
    it { is_expected.to(belong_to(:author)) }
  end
end
