# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationHelper, type: :helper) do
  describe "#page_title" do
    context "on show, edit, and update with a named record" do
      it "uses the record name on show" do
        allow(helper).to(receive(:controller_name).and_return("authors"))
        allow(helper).to(receive(:action_name).and_return("show"))
        assign(:author, Author.new(name: "Frank Miller"))

        expect(helper.page_title).to(eq("Frank Miller | Meus Quadrinhos"))
      end

      it "uses the record name on edit" do
        allow(helper).to(receive(:controller_name).and_return("authors"))
        allow(helper).to(receive(:action_name).and_return("edit"))
        assign(:author, Author.new(name: "Frank Miller"))

        expect(helper.page_title).to(eq("Frank Miller | Meus Quadrinhos"))
      end

      it "keeps the record name when an update fails" do
        allow(helper).to(receive(:controller_name).and_return("authors"))
        allow(helper).to(receive(:action_name).and_return("update"))
        assign(:author, Author.new(name: "Frank Miller"))

        expect(helper.page_title).to(eq("Frank Miller | Meus Quadrinhos"))
      end

      it "prefers display_title for comics" do
        allow(helper).to(receive(:controller_name).and_return("comics"))
        allow(helper).to(receive(:action_name).and_return("show"))
        assign(
          :comic,
          Comic.new(
            title: "Batman",
            issue_number: 1,
            collection: Collection.new(name: "Absolute"),
          ),
        )

        expect(helper.page_title).to(eq("Batman n° 1 | Meus Quadrinhos"))
      end

      it "uses the comic title when editing readings" do
        allow(helper).to(receive(:controller_name).and_return("comic_memberships"))
        allow(helper).to(receive(:action_name).and_return("edit"))
        assign(:comic, Comic.new(title: "Batman"))

        expect(helper.page_title).to(eq("Batman | Meus Quadrinhos"))
      end

      it "keeps the comic title when updating readings fails" do
        allow(helper).to(receive(:controller_name).and_return("comic_memberships"))
        allow(helper).to(receive(:action_name).and_return("update"))
        assign(:comic, Comic.new(title: "Batman"))

        expect(helper.page_title).to(eq("Batman | Meus Quadrinhos"))
      end
    end

    context "on show, edit, and update without a usable record name" do
      it "falls back to the section when the record name is blank" do
        allow(helper).to(receive(:controller_name).and_return("authors"))
        allow(helper).to(receive(:action_name).and_return("show"))
        assign(:author, Author.new(name: ""))

        expect(helper.page_title).to(eq("Autores | Meus Quadrinhos"))
      end

      it "falls back to the section when the record is missing" do
        allow(helper).to(receive(:controller_name).and_return("authors"))
        allow(helper).to(receive(:action_name).and_return("show"))

        expect(helper.page_title).to(eq("Autores | Meus Quadrinhos"))
      end
    end

    context "on new and create" do
      it "uses the singular model name on new" do
        allow(helper).to(receive(:controller_name).and_return("authors"))
        allow(helper).to(receive(:action_name).and_return("new"))
        assign(:author, Author.new)

        expect(helper.page_title).to(eq("Novo | Autor | Meus Quadrinhos"))
      end

      it "keeps Novo and the singular model name when create fails" do
        allow(helper).to(receive(:controller_name).and_return("authors"))
        allow(helper).to(receive(:action_name).and_return("create"))
        assign(:author, Author.new(name: "Frank Miller"))

        expect(helper.page_title).to(eq("Novo | Autor | Meus Quadrinhos"))
      end
    end

    context "on authentication pages" do
      it "does not prefix Novo on the login page" do
        allow(helper).to(receive(:controller_name).and_return("sessions"))
        allow(helper).to(receive(:action_name).and_return("new"))

        expect(helper.page_title).to(eq("Entrar | Meus Quadrinhos"))
      end

      it "does not prefix Novo on the registration page" do
        allow(helper).to(receive(:controller_name).and_return("registrations"))
        allow(helper).to(receive(:action_name).and_return("new"))

        expect(helper.page_title).to(eq("Registrar | Meus Quadrinhos"))
      end

      it "does not prefix Novo on the password recovery page" do
        allow(helper).to(receive(:controller_name).and_return("passwords"))
        allow(helper).to(receive(:action_name).and_return("new"))

        expect(helper.page_title).to(eq("Esqueci minha senha | Meus Quadrinhos"))
      end
    end

    context "on index and other section pages" do
      it "uses the controller section on index" do
        allow(helper).to(receive(:controller_name).and_return("authors"))
        allow(helper).to(receive(:action_name).and_return("index"))

        expect(helper.page_title).to(eq("Autores | Meus Quadrinhos"))
      end

      it "uses the controller section on the dashboard" do
        allow(helper).to(receive(:controller_name).and_return("welcome"))
        allow(helper).to(receive(:action_name).and_return("index"))

        expect(helper.page_title).to(eq("Dashboard | Meus Quadrinhos"))
      end

      it "uses the controller section on browse" do
        allow(helper).to(receive(:controller_name).and_return("comics"))
        allow(helper).to(receive(:action_name).and_return("browse"))

        expect(helper.page_title).to(eq("Quadrinhos | Meus Quadrinhos"))
      end

      it "uses the controller section on the engine room" do
        allow(helper).to(receive(:controller_name).and_return("engine_rooms"))
        allow(helper).to(receive(:action_name).and_return("show"))

        expect(helper.page_title).to(eq("Sala de máquinas | Meus Quadrinhos"))
      end
    end
  end
end
