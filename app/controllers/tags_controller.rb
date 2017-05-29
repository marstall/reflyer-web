class TagsController < ApplicationController

  def search
    if (params[:category])
      render json: Tag.popular_within_category(params[:category]).to_json
    else
      render json: Tag.where(["text like ?","#{params[:query]}%"]).to_json
    end
  end
  
  
end

   