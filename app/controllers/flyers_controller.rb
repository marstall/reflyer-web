class FlyersController < ApplicationController

  def load_or_create_user
    user_id = params[:user_id]
    device_id = params[:user_device_id]
    if user_id
      @user = User.find(user_id)
    elsif device_id
      @user = User.find_or_create_by(device_id:device_id)
    end
    @user.update_attributes(user_params) if params[:user]
    @user.save
  end
  
  def load_flyers
    @page_size=50
    @tags=params[:tags]
    @start = params[:start]||0
    @lat = params[:lat]
    @lng = params[:lng]
    @radius = params[:radius]
    @num = params[:num]||@page_size
    @query = params["tag"]["text"] if params["tag"]
    @query= nil if @query and @query.strip.size==0
    @tags=nil if @tags=='all'
    @header_title=@tags
    @header_title="##@header_title" unless Tag.is_supertag(@tags) or @tags.nil? or @tags.empty?

  	@page_title="#{@metro_code} ##@tags events"

    @order=params[:order] || get_cookie(:order)
#    @order = "random" #if not @order
    set_cookie(:order,@order)
    order_hash=
    {
      "created"=>"created_at desc",
      "popular"=>"created_at desc",
      "date"=>"date desc",
      "random"=>"rand()"
    }
    _order = order_hash[@order]

    options = {
              :show_flagged=>params[:show_flagged]
              }
    params = {
              :lat=>@lat,
              :lng=>@lng,
              :radius=>@radius,
              :order=>_order,
              :tags=>@tags,
              :query=>@query,
              :start=>@start,
              :num=>@num
             }
             @flyers = Flyer.all_flyers(params,options)
  end

  def blob 
    load_or_create_user
    save_request
    load_flyers
  end

  def save_request
    request = Request.new
    request.user_id = @user.id
    request.resource = 'blob'
    request.save
  end

  def index
    load_flyers
    render json: @flyers, include: ['place']
  end
  
  def show
    @flyer = Flyer.find(params[:id])
    render(:inline=>"unrecognized id") and return unless @flyer
    @page_title = @flyer.body
    @hide_login=true
    render(:layout=>'minimal_layout')
  end

  def create
    if place_params["source_id"]
      @place = Place.find_by(source_id:place_params["source_id"]) 
      if not @place 
        @place = Place.new(place_params)
        @place.save
        Place.where(id:@place.id).update_all("latlng=st_geomfromtext('point(#{@lng} #{@lat})')")
      end
    end

    @flyer = Flyer.new( flyer_params )
    @flyer.place = @place
    @flyer.save!
    Flyer.where(id:@flyer.id).update_all("latlng=st_geomfromtext('point(#{@lng} #{@lat})')") if @lng and @lat
    render json: @flyer, include: ['place']
  end

  def update
    id = params[:flyer_id]
    flyer = Flyer.find(params[:id])
    flyer.update_attributes(flyer_params)
    flyer.save
    head :ok
  end

  def delete
    id = params[:id]
    begin
      @flyer=Flyer.find(id)
    rescue
    end
    if not @flyer
      render(:inline=>'unkown id')
      return
    end
    if (@youser.is_admin or @flyer.is_owner(@youser))
      Flyer.find(id).destroy
      FlyerMailer::deliver_flyer_edited(@flyer, metro_code, @youser, "deleted flyer" ) if ENV['RAILS_ENV']!='development'
      flash[:notice]="flyer successfully deleted."
      redirect_to("/")
    end
  end
  
  
  private 

  def user_params
    params.require(:user).permit([:id,:metro_code,:expo_push_token,:device_id])
  end

  def flyer_params
    params.require(:flyer).permit([:user_id,:image,:title,:buzz,:body,
      :category,:lat,:lng, :start_date,:end_date,:score,:date_type])
  end

  def place_params
    return {} unless params[:flyer][:place]
    place_params = JSON.parse(params[:flyer][:place])
    location = place_params["location"]
    place_params = place_params.merge(location)
    @lng = location["lng"]
    @lat = location["lat"]
    place_params["lat"]=@lat
    place_params["lng"]=@lng
    #place_params[:latlng] = "st_geomfromtext('place(#{lng} #{lat})')"
    place_params["source"] = "foursquare"
    place_params["source_id"] = place_params["id"]
    place_params["formatted_address"]=place_params["formattedAddress"]
    place_params = place_params.reject{|key,value|
      !["name","formatted_address","city","state","country","source_id","lat","lng","source"].include?(key)
    }
    place_params
  end
  
  
end
