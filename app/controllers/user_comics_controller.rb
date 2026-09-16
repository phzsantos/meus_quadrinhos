# frozen_string_literal: true

class UserComicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comic

  def create
    current_user.user_comics.find_or_create_by!(comic: @comic)

    redirect_to(
      browse_comics_path,
      notice: "#{@comic.display_title} adicionado à sua coleção.",
    )
  end

  def destroy
    current_user.user_comics.find_by(comic: @comic)&.destroy!

    redirect_to(
      comic_path(@comic),
      notice: "#{@comic.display_title} removido da sua coleção.",
    )
  end

  private

  def set_comic
    @comic = Comic.friendly.find(params[:comic_id])
  end
end
