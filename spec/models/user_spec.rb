# frozen_string_literal: true

require "rails_helper"

RSpec.describe(User, type: :model) do
  subject { build(:user) }

  describe "validações" do
    it { is_expected.to(validate_presence_of(:username)) }

    it { is_expected.to(validate_uniqueness_of(:username)) }

    it { is_expected.to(validate_presence_of(:email)) }

    it { is_expected.to(validate_presence_of(:password)) }
  end

  describe "admin" do
    it "tem admin como false por padrão" do
      user = create(:user)

      expect(user.admin).to(be(false))
    end

    it "permite admin true via trait" do
      admin = create(:user, :admin)

      expect(admin.admin).to(be(true))
    end
  end
end
