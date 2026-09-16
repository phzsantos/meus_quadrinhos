# frozen_string_literal: true

class ReadingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comic

  def create
    reading = current_user.readings.new(comic: @comic, read_at: reading_params[:read_at])

    if reading.save
      redirect_to(
        redirect_after_create,
        notice: "Leitura de #{@comic.display_title} registrada.",
      )
    else
      redirect_to(
        redirect_after_create,
        alert: reading.errors.full_messages.to_sentence.presence || "Não foi possível registrar a leitura.",
      )
    end
  end

  private

  def set_comic
    @comic = Comic.friendly.find(params[:comic_id])
  end

  def reading_params
    params.require(:reading).permit(:read_at)
  end

  def redirect_after_create
    case params[:return_to]
    when "browse" then browse_comics_path
    else comic_path(@comic)
    end
  end
end
