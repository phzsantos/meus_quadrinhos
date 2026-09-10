# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Reading, type: :model) do
  subject(:reading) { build(:reading) }

  describe "associations" do
    it { is_expected.to(belong_to(:comic)) }
    it { is_expected.to(belong_to(:user)) }
  end

  describe "validations" do
    it { is_expected.to(validate_presence_of(:read_at)) }
  end
end
