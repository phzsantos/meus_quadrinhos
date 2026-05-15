# frozen_string_literal: true

class PublishersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, except: [:index, :show]
  before_action :set_publisher, only: [:show, :edit, :update, :destroy]

  # GET /publishers or /publishers.json
  def index
    @publishers = Publisher
      .includes(:comics)
      .order(:name)
      .page(params[:page])
      .per(20)
  end

  # GET /publishers/1 or /publishers/1.json
  def show
    @comics = @publisher.comics.order(:title, :issue_number).page(params[:page]).per(18)
  end

  # GET /publishers/new
  def new
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit
  end

  # POST /publishers or /publishers.json
  def create
    @publisher = Publisher.new(publisher_params)

    respond_to do |format|
      if @publisher.save
        format.html { redirect_to(@publisher, notice: "Editora criada com sucesso.") }
        format.json { render(:show, status: :created, location: @publisher) }
      else
        format.html { render(:new, status: :unprocessable_content) }
        format.json { render(json: @publisher.errors, status: :unprocessable_content) }
      end
    end
  end

  # PATCH/PUT /publishers/1 or /publishers/1.json
  def update
    respond_to do |format|
      if @publisher.update(publisher_params)
        format.html { redirect_to(@publisher, notice: "Editora atualizada com sucesso.", status: :see_other) }
        format.json { render(:show, status: :ok, location: @publisher) }
      else
        format.html { render(:edit, status: :unprocessable_content) }
        format.json { render(json: @publisher.errors, status: :unprocessable_content) }
      end
    end
  end

  # DELETE /publishers/1 or /publishers/1.json
  def destroy
    if @publisher.destroy
      redirect_to(
        publishers_path,
        notice: "Editora foi deletada com sucesso.",
        status: :see_other,
      )
    else
      redirect_to(
        publishers_path,
        alert: @publisher.errors.full_messages.to_sentence,
        status: :see_other,
      )
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_publisher
    @publisher = Publisher.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def publisher_params
    params.require(:publisher).permit(:name)
  end
end
