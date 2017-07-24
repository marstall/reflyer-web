# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'rubygems'
require 'fileutils'
require 'digest/md5'


class ApplicationController < ActionController::Base
  
=begin
	["choose one - required",""],
	["rock","rock"], 
	["jazz","jazz"],
	["classical","classical"],
	["rap","rap"],
	["dj","dj"],
	["comedy","comedy"],
	["movie","movie"],
	["theatre","theatre"],
	["dance","dance"],
	["art","art"],
	["reading","reading"],
	["other","other"]]
=end
  
  def page_size
    50
  end

  def portrait_flyer_width
    400
  end

  def landscape_flyer_width
    450
  end

  HTML_REGEXP=/[<>]|(update|delete|insert)\s/
  SALT="BRUN TAXMAN"
#  before_filter :perform_hostname_corrections
#  before_filter :signup_intercept, :only=>[:homepage]
#  before_filter :convert_to_new_url_structure_2
  before_filter :initialize_user, :except => :login
  before_filter :mark_time
  before_filter :ensure_www
  before_filter :setup_options

  def setup_options
    @options=cookies 
    
  end

  def domain_stub
    @domain_stub
  end
  
  def domain
    if ENV['RAILS_ENV']=='development'
      return "www.tourfilter.local:3000"
    else
      return "www.tourfilter.com"
    end
  end

  def local_request?
    false
    #true
  end

  
  def created(object,info=nil)
    Event.created(@youser,object,info)
  end

  def updated(object,info=nil)
    Event.updated(@youser,object,info)
  end

  def deleted(object,info=nil)
    Event.deleted(@youser,object,info)
  end

  def viewed(object,info=nil)
    Event.viewed(@youser,object,"view",info)
  end

  def ensure_www
    return true
    if request.host=='tourfilter.com'
      redirect_to "http://www.tourfilter.com#{request.path}"
      return false     
    end
    return true if request.host=~/antiplex|amazon|localhost|tourfilter\.(com|local)|^192.168/
    return true if request.env['HTTP_REFERER']=~/ELB-HealthChecker/
    redirect_to "http://www.tourfilter.com#{request.path}"
    return false     
  end
 

  def is_admin?
    return true
    #session[:is_admin]
  end

  def must_be_admin
    return false if not must_be_known_user
    return true if is_admin?
    if !@youser.privs||@youser.privs!="admin"
      flash[:error]="You don't have permission to access that page!"
      redirect_to '/'
      return false 
    end
    return true
  end

  def must_be_known_user_no_message
    if !@youser_known
      redirect_to login_url
      return false
    end
    return true
  end

  def must_be_known_user(msg=nil)
    msg||="You must be logged in to do that!"
    return true if session[:is_admin]
    if !@youser_known
      flash[:error]=msg
      redirect_to signup_url
      return false
    end
    return true
  end
  
  

  def login_url(redirect_url=nil)
    redirect_url||=request.path+URI::escape("?#{request.query_string}")
    "/login?redirect_url=#{redirect_url}"
  end

  def signup_url(redirect_url=nil)
    redirect_url||=request.path+URI::escape("?#{request.query_string}")
    "/basic_signup?redirect_url=#{redirect_url}"
  end

  def _signup_url(params)
    redirect_url||=request.path+URI::escape("?#{request.query_string}")
    "/signup?redirect_url=#{redirect_url}"
  end

  def basic_signup_url(redirect_url=nil)
    redirect_url||=request.path
    "/basic_signup?redirect_url=#{redirect_url}"
  end
  
  def mark_time
    @before = Time.new
    return true
  end
  
  def start_timer
    @timer=Time.new
  end
  
  def log_interval(label='')
    interval = Time.new-@timer
    #logger.info("+++ TIME #{label}: #{interval}")
  end
  
  def get_cookie(name)
    cookies[name]
  end
  
  def set_cookie(name,value,path="/",expires=10.years.from_now)
    cookies[name] = {
                          :value => value,
                          :expires => expires,
                          :path => path
                    }
  end
  
  def set_tracking_cookie
    # generate permanent tracking cookie based on session_id
    cookies[:psid] = {
                          :value => String(session.id),
                          :expires => 10.years.from_now,
                          :path => "/#{@metro_code}"
                        }     if not cookies[:psid]
    return true
  end
  
  def set_referer_cookie
    # extract referer_domain and put that in the cookie if the user is not logged in
    referer = request.env['HTTP_REFERER']
    return true if not referer or referer.empty?
#    #logger.info("SETTING REFERER COOKIE TO #{referer}")
    cookies[:ref] = {
                          :value => String(referer),
                          :expires => 10.years.from_now,
                          :domain => ".tourfilter.com",
                          :path => "/"
                      } if referer !~ /tourfilter\.(com|local)/
#                      } if referer !~ /^http\:\/\/\w{1,32}\.tourfilter\.(com|local)/
    return true
  end

  def record_visit
    # once per session, record the time and user-agent of the user in the user-record
    visit_recorded=session[:visit_recorded]
    if visit_recorded!="1"
      session[:visit_recorded]="1"
      @youser.last_user_agent=request.user_agent
      @youser.last_visited_on=DateTime.now
      @youser.save
    end
      
  end
  
 def generate_cookie_hash(youser_id)
#    #logger.info("youser_id: #{youser_id}")
#    #logger.info("request.remote_ip: #{request.remote_ip}")
    hash = Digest::MD5.hexdigest("#{youser_id}|#{request.remote_ip}|#{@metro_code}|#{SALT}")
#    #logger.info("hash: #{hash}")
    hash
  end
  def initialize_user
    @youser = User.find_by(email_address:'chris@reflyer.com')
    @youser_known = true
  end
  
  def initialize_user_
    @youser_known = false
    @youser_logged_in = false
    cookie_user_id = cookies[:"#{@metro_code}_user_id"]
    id_hash = cookies[:"#{@metro_code}_id_hash"]
    session_user_id = session[:"#{@metro_code}_user_id"]
    if !session_user_id.nil?
      @youser_known = true
      @youser_logged_in = true
      @youser_id = session_user_id
    end
    if cookie_user_id and id_hash
      session[:"#{@metro_code}_user_id"]=cookie_user_id
      compare_hash = generate_cookie_hash(cookie_user_id)
      if id_hash!=compare_hash
        cookies[:"#{@metro_code}_user_id"]=""
        cookies[:"#{@metro_code}_id_hash"]=""
        @youser_known = false
        @youser_logged_in = false
        @youser_id = nil
      else
        @youser_known = true  
        @youser_logged_in = true
        @youser_id = cookie_user_id
      end
    end
    begin
      if @youser_known
        @youser = User.find(@youser_id)
        
        record_visit
      end
    rescue      
      logout
      return true
    end
    if @youser
      #logger.info("@youser: #{@youser.name}") 
    else
      #logger.info("not logged in") 
    end
    return true
  end
  
  def login
    login_with_name_password(params[:name],params[:password])
  end
  
  def login_user (user,redirect=true)
    name=user.name
    name=user.email_address if user.registration_type=="basic"

    login_with_name_password(name,user.password,redirect)
  end
  
  def login_with_name_password(name,password,redirect=true)
    if request.post?
      # HACK
      if name=~/\@/
        @youser = User.find_by_email_address_and_password(name,password) 
      else
        @youser= User.find_by_name_and_password(name,password)
      end
      if @youser.nil?
        @youser= User.find_by_email_address_and_password(name,password)
      end
      if @youser.nil?
        url = "/#{@metro_code}/lost_password"
        flash[:notice] = "Unknown username and/or password. Did you <a href='#{url}'>forget your password?</a>"
        redirect_to request.env['HTTP_REFERER'] # just refresh the page
        return
      else
        @youser.last_logged_in_on=DateTime.now
        @youser.metro_code=@metro_code
        #logger.info( "+++ #{metro_code}: #{@youser.metro_code}")
        @youser.save 
#        cookies['calndar_view']='add_SP_bands'
        
#       domain="#{@metro_code}.#{@domain_stub}" 
#       domain=@domain_stub if @youser.privs=='admin' 
#        cookies[:calendar_view] = {
#                      :value => "my",
#                      :expires => 360.days.from_now,
#                      :path => "/#{@metro_code}"
#                    }
        session[:"#{@metro_code}_user_id"] = @youser.id
        session[:is_admin] = true if @youser.privs=~/admin/ # for all cities, note!!
        cookies[:"#{@metro_code}_user_id"] = {
                              :value => String(@youser.id),
#                              :domain => domain,
                              :expires => 360.days.from_now,
                              :path => "/#{@metro_code}"
                            }
        cookies['admin']='1'
        id_hash= generate_cookie_hash(@youser.id)
        cookies[:"#{@metro_code}_id_hash"] = {
                              :value => String(id_hash),
                              :expires => 360.days.from_now,
                              :path => "/#{@metro_code}"
                            }
        if @youser.privs=~/admin|manage_matches/
          cookies[:"manage_matches"] = {
                              :value => 'true',
                              :expires => 360.days.from_now,
                              :path => "/#{@metro_code}"
                            }
        end
      end
#      if request.env['HTTP_REFERER'] =~ /edit/
#        redirect_to(:controller => "home")
#      else
#        flash[:notice] = 'Logged in!' unless flash[:notice]
#        redirect_to request.env['HTTP_REFERER'] if redirect # just refresh the page
       redirect_url=params[:redirect_url]||"/"
       redirect_to redirect_url if redirect
#      end
    end
  end
  
  def logout
    cookies['calndar_view']='flyers'
    session[:"#{@metro_code}_user_id"] = nil
    session[:is_admin]= nil
    cookies[:calendar_view] = {
                          :value => "",
                          :expires => 360.days.from_now,
                          :path => "/#{@metro_code}"
                        }
    cookies[:"#{@metro_code}_user_id"] = {
                          :value => "",
                          :expires => 360.days.from_now,
                          :path => "/#{@metro_code}"
                        }
    cookies[:"#{@metro_code}_id_hash"] = {
                          :value => "",
                          :expires => 360.days.from_now,
                          :path => "/#{@metro_code}"
                        }
    cookies[:"manage_matches"] = {
                        :value => '',
                        :expires => 360.days.from_now,
                        :path => "/#{@metro_code}"
                      }
#    flash[:notice] = 'Logged out!'
    redirect_to "/"
  end

  def logout_test
    output="logout: #{@metro_code} #{@metro_code}_user_id #{@metro_code}_id_hash<br><br><br>"
    output+="cookies.inspect before logout: #{cookies.inspect}<br><br><br>"
    session[:"#{@metro_code}_user_id"] = nil;
    cookies.delete :"#{@metro_code}_user_id"
    cookies.delete :"#{@metro_code}_id_hash"
    cookies.delete "#{@metro_code}_user_id"
    cookies.delete "#{@metro_code}_id_hash"
    output+="cookies.inspect after logout: #{cookies.inspect}<br><br><br>"
    render(:inline=>output)
  end

 

  def use_full_width_footer
    @full_width_footer=true
  end
   

  def rescue_action_in_public(e)
    log_error(e)
    super(e)
  end

  def log_error(exception) 
    super(exception)
    return
    begin
      if exception.message !~/No route matches/
        ExceptionMailer.deliver_snapshot(@metro_code,
          exception, 
          clean_backtrace(exception),
          @session.instance_variable_get("@data"), 
          @params, 
          request.env)# if ENV['RAILS_ENV']=='production'
      end
    rescue => e
      logger.error(e)
    end
  end  
  
  protected  
  
  def log_time(label)
    #logger.info("#{label} => #{Time.now.to_f}")
  end
end
