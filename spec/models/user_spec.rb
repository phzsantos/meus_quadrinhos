# frozen_string_literal: true

require "rails_helper"

RSpec.describe(User, type: :model) do
  subject { build(:user) }

  describe "associations" do
    it { is_expected.to(have_many(:user_comics).dependent(:destroy)) }
    it { is_expected.to(have_many(:owned_comics).through(:user_comics).source(:comic)) }
    it { is_expected.to(have_many(:readings).dependent(:destroy)) }
  end

  describe "validations" do
    it { is_expected.to(validate_presence_of(:username)) }

    it { is_expected.to(validate_uniqueness_of(:username)) }

    it { is_expected.to(validate_presence_of(:email)) }

    it { is_expected.to(validate_presence_of(:password)) }
  end

  describe "admin" do
    it "has admin as false by default" do
      user = create(:user)

      expect(user.admin).to(be(false))
    end

    it "allows admin to be true via trait" do
      admin = create(:user, :admin)

      expect(admin.admin).to(be(true))
    end
  end
end
