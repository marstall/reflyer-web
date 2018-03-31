# == Schema Information
#
# Table name: flyers
#
#  id                 :integer          not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  user_id            :integer
#  image_url          :string(255)
#  flagged            :string(255)
#  status             :string(8)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  image_fingerprint  :string(64)
#  body               :text(65535)
#  venue_name         :string(255)
#  category           :string(255)
#  latlng             :integer
#  place_id           :integer
#  lat                :float(53)
#  lng                :float(53)
#  start_date         :datetime
#  end_date           :datetime
#  title              :string(255)
#  buzz               :text(65535)
#  score              :integer          default(0), not null
#  date_type          :string(255)
#

class Flyer < ApplicationRecord
  IMAGE_QUALITY=50  # max 100
  DEFAULT_RADIUS=10 # miles

  CONVERT_OPTIONS = <<-_
    -strip 
    -interlace Plane 
    -sampling-factor 4:2:0 
    -define jpeg:dct-method=float 
    -quality #{IMAGE_QUALITY}% 
  _
  
  belongs_to :user
  belongs_to :place
  has_many :tags, :through => :taggings
  has_many :user_actions
  has_many :taggings


  has_attached_file :image, styles: {
                                      original: {convert_options: "-strip"},
                                      medium: "750x750> ", 
                                      thumb:"250x250>"
                            }, 
                            convert_options: {
                              medium: CONVERT_OPTIONS,
                              thumb: CONVERT_OPTIONS
                            }


  validates_attachment_content_type :image, :content_type => /\Aimage/
  validates_attachment_size :image, :less_than => 10.megabytes
  validates_attachment_presence :image
  do_not_validate_attachment_file_type :image
    
  #attr_accessor :post_as

#  has_many :taggings,:dependent=>:destroy
#  has_many :tags, :as=>:hashtags, :through=>:taggings
  
  def formatted_buzz
    buzz.gsub("\r","<br>")
  end

  def medium_url
    image.url(:medium)
  end

  def thumb_url
    image.url(:thumb)
  end

  def original_url
    image.url
  end

  def age
    (Time.now.to_date - created_at.to_date).to_int
  end
  
  def iso8601_start_date
    start_date ? start_date.iso8601 : nil
  end

  def iso8601_end_date
    end_date ? end_date.iso8601 : nil
  end
  
  def num_user_actions
    return user_actions.count
  end

  def pretty_date(date)
    today = DateTime.now.midnight
    diff = date-today
    s=""
    case diff
    when 0
      s="Today"
    when 1
      s="Tomorrow"
    when 2..6
      s= date.strftime("%a, %b %e")
    else
      s= date.strftime("%b %e")
    end
  end
  
  def date_string 
    today = DateTime.now.midnight
    start_diff = start_date-today
    end_diff = end_date-today
    pretty_start = pretty_date(start_date)
    pretty_end = pretty_date(end_date)
    if start_date==end_date 
      return pretty_start
    else 
      s=""
      if start_diff<0
        case start_diff
        when 0
          s="today through #{pretty_end}"
        else
          case end_diff
          when 0..1
            s = "ends today!"
          when 2..5
            s = "ends #{pretty_end}"
          else
            s = "through #{pretty_end}"
          end
        end
      else
        return "#{pretty_start} - #{pretty_end}"
      end
    end
  end
=begin      
    let startDiff = moment(this.iso8601_start_date).diff(today)
    let endDiff = moment(this.iso8601_end_date).diff(today)
    let startDate = this.prettyDate(this.iso8601_start_date)
    let endDate = this.prettyDate(this.iso8601_end_date)
    if (startDate == endDate) {
      return startDate
    } else {
      if (startDiff < 0) {
        let s
        switch (startDiff) {
          case 0:
            s = `today through ${endDate}`
          default:
            switch (endDiff) {
              case 0:
                s = `ends today!`
                break
              case 1:
              case 2:
              case 3:
              case 4:
              case 5:
                s = `ends ${endDate}`
                break
              default:
                s = `through ${endDate}`
                break
            }
            break
        }
        return s
      } else {
        return `${startDate} - ${endDate}`
      }
    }
  }
    

=end

  def Flyer.count_future_flyers(metro_code)
    sql = <<-SQL
    select count(distinct id) from flyers
      where flyers.created_at>adddate(now(),interval -7 day)
      and flagged is null and image_file_name is not null
    SQL
    return Flyer.count_by_sql(sql)
  end
  
  def Flyer.popular_flyers(params={},options={})
    limit = 6#options[:limit]||50
    tags=params[:tags]
    select_sql=""
    if tags
      if Tag.is_supertag(tags)
        tags_sql = " and category=?"
      else
       select_sql +=",taggings,tags"
       tags_sql = "and taggings.flyer_id=flyers.id and taggings.tag_id=tags.id and tags.text=?"
      end
    else
      tags_sql = ""
    end
    
    sql = <<-SQL
      select flyers.*,count(*) cnt
      from flyers,flyers_users 
      #{select_sql}
      where flyers_users.flyer_id=flyers.id
      and (flyers.date>adddate(now(),interval -20 hour) or flyers.end_date>adddate(now(),interval -20 hour))
      and flyers_users.created_at>adddate(now(),interval -180 day)
      and flyers_users.deleted_flag=false
      #{tags_sql}
      group by flyers.id
      order by cnt desc limit ?
    SQL
    args=[sql]
    args<<tags if tags
    args<<limit
    
    return Flyer.find_by_sql(args)
  end
  
  def Flyer.params_valid(params)
    lat=params[:lat]
    lng=params[:lng]
    radius=params[:radius]
    puts "radius.to_f: #{radius.to_f}"
    if (!lat && !lng) || (lat.to_f!=0 && lng.to_f!=0 && radius.to_f!=0)
      return true
    else
      return false
    end
  end

  def Flyer.all_flyers(params={},options={})
     if !Flyer.params_valid(params)
       Rails.logger.info("invalid params to all_flyers: #{params}")
       raise "invalid params to all_flyers: #{params}"
     end
     options||={}
     tags=params[:tags]
     query=params[:query]
     lat=params[:lat]
     lng=params[:lng]
     radius=params[:radius]
     user_id=params[:user_id]
     user = params[:user]
     #puts "!!! possible sql injection" and return nil if tags!=/^[a-z]$/ #sql injection
     order=params[:order]||'flyers.created_at desc'
     num=params[:num]||50
     start=params[:start]||0

     select_sql = "select flyers.* from flyers"
     order_sql= params[:order] || 'flyers.score desc,flyers.created_at desc'
     group_by_sql = "group by flyers.id"
     
     if tags
       if Tag.is_supertag(tags)
         tags_sql = " and category=?"
       else
        select_sql +=",taggings,tags"
        tags_sql = "and taggings.flyer_id=flyers.id and taggings.tag_id=tags.id and tags.text=?"
       end
     else
       tags_sql = ""
     end
     query_sql =""
     if query
       query
       query_sql = " and (body like ? or username=? or category=?)"
     end

     if lat && lng
       radius||=DEFAULT_RADIUS
       radius_in_meters = radius.to_i*1600
       select_sql +=",places"
       location_sql=" and place_id=places.id "
       location_sql+=" and st_distance(st_geomfromtext('point(#{lng} #{lat})'),places.latlng)*103312 < #{radius_in_meters} "
     end
     if user_id
       order= 'ieu.created_at desc'
       select_sql+=",flyers_users ieu"
       user_id_sql = " and ieu.flyer_id=flyers.id and ieu.user_id=#{user_id} and ieu.deleted_flag=false "
     end
     recommenders_sql = ""
     if options[:show_recommenders]
       if user and user.recommenders``.size>0
         order_sql= 'ieu.created_at desc'         
         select_sql+=",flyers_users ieu"
         ids  = user.recommenders.collect{|u|u.id}.join(",")
         recommenders_sql = " and ieu.flyer_id=flyers.id and ieu.user_id in (#{ids}) and ieu.deleted_flag=false "
         group_by_sql = " group by flyer_id,user_id "
       else
         return []
       end
     end

     if options[:show_flagged]=="flagged_only"
       flagged_sql = " and flagged is not null"
     else
       flagged_sql = " and flagged is null"
     end
     sql = <<-SQL
        #{select_sql}
        where image_file_name is not null
        and flyers.end_date>=now()
        #{flagged_sql}
        #{tags_sql}
        #{query_sql}
        #{location_sql}
        #{user_id_sql}
        #{group_by_sql}
        order by #{order_sql}
        limit ?
        offset ?
      SQL
      args=[sql]
      args<<tags if tags
      if query
        args<<"%#{query}%" 
        args<<query
        args<<query.sub("#","")
      end
      args<<num.to_i
      args<<start.to_i
      puts sql
      Flyer.find_by_sql(args)
    end
  
  def has_text?
    return true if body and body.strip.size>0
    return true if venue_name and venue_name.strip.size>0
  end
  
  def is_owner(user)
    return false if (not user)
    (user.id==user_id)
  end
  
  def do_hashtag_process
    tags = []
    Tagging.delete_all("flyer_id=#{id}")
    body.scan(/\#[^\s]+/).each{|_tag|
      tag = Tag.find_or_create(_tag)
      tags<<tag
      tagging = Tagging.new
      tagging.flyer_id=id
      tagging.tag_id=tag.id
      tagging.save
    }  if body
    return tags
  end
  

  def very_short_time_description
    today = DateTime.now.midnight
    date = start_date
	 	 "in #{distance_of_time_in_words(today,date)}"
  end
  
  def oneup_url(metro_code)
    "/flyer/#{id}"
  end

  def short_time_description
	 	  "#{Date::MONTHNAMES[created_at.month]} #{created_at.day}"
  end
  

end
