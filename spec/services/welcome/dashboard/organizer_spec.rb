# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Welcome::Dashboard::Organizer) do
  subject(:call_organizer) { described_class.call }

  describe ".call" do
    it "executa o fluxo completo do dashboard sem erros" do
      expect(call_organizer).to(be_success)
    end

    it "retorna um contexto compartilhado entre todos os interactors" do
      expect(call_organizer).to(be_a(Interactor::Context))
    end
  end
end
