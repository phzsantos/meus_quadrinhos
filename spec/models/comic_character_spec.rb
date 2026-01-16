# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ComicCharacter, type: :model) do
  subject(:comic_character) { build(:comic_character) }

  describe "associations" do
    it { is_expected.to(belong_to(:comic)) }
    it { is_expected.to(belong_to(:character)) }
  end
end
