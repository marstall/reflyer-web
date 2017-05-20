class TagsController < ApplicationController

  def search
    render json: Tag.where(["text like ?","#{params[:query]}%"]).pluck(:text).to_json
  end
end

   