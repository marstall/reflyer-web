# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'rubygems'
require 'fileutils'
require 'digest/md5'


class ApplicationController < ActionController::Base
  
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
  before_filter :mark_time
  before_filter :ensure_www

  def domain_stub
    @domain_stub
  end
  
  def domain
    if ENV['RAILS_ENV']=='development'
      return "www.reflyer.local:3000"
    else
      return "www.reflyer.com"
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
    if request.host=='reflyer.com'
      redirect_to "http://www.refyer.com#{request.path}"
      return false     
    end
    return true if request.host=~/reflyer|amazon|localhost\.(com|local)|^192.168/
    return true if request.env['HTTP_REFERER']=~/ELB-HealthChecker/
    redirect_to "http://www.reflyer.com#{request.path}"
    return false     
  end
 

  def is_admin?
    @youser and @youser.is_admin?
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
