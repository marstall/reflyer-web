require 'cloudinary'

class Hash
  def +(add)
    temp = {}
    add.each{|k,v| temp[k] = v}
    self.each{|k,v| temp[k] = v}
    temp
  end
end

module ApplicationHelper

  require 'lorem_ipsum.rb' 
  

    def matches2calendar(_matches)
      days=Array.new
      matches=Hash.new
  #    matched_term_ids=Hash.new
      _matches.each{|match|
        next unless match.day
        if not matches[match.date_for_sorting]
          days<<match.date_for_sorting 
          matches[match.date_for_sorting]=Array.new
        end
        matches[match.date_for_sorting]<<match
  #      matched_term_ids[match.term_id]=true
      }
      return [days,matches]
    end

  def is_admin?
    @youser and @youser.is_admin
    #session[:is_admin]
  end
  
  def homepage_by_venue?
    return false
  end

  def encode(s)
    return "" if s.nil?
    s = URI::encode(s)
    s.gsub! "&", "%26"
    s.gsub! "?", "%3F"
    s.gsub! "+", "%2B"
    s
  end

  def is_today(dt)
    DateTime.now.day==dt.day and DateTime.now.month==dt.month and DateTime.now.year==dt.year
  end
  
  
  def login_url(redirect_url=nil)
    redirect_url||=request.path
    "/login?redirect_url=#{redirect_url}"
  end

  def signup_url(params)
    redirect_url=params[:redirect_url]||"/"
    "/basic_signup?redirect_url=#{redirect_url}"
  end
    
  def url(url)
    return unless url =~ /^\//
    # add metro_code to url
    "/#{controller.metro_code}#{url}"
  end
  
  def math_based_form_validator
#	  value1=(Math.round(100*Math.random())+1)
#	  value2=(Math.round(100*Math.random())+1)
#    <<-HTML
#      <input type="hidden" name="value1" value="#{value1}">
#      <input type="hidden" name="value2" value="#{value2}">
#      <form>
#    HTML
  end
  
  def set_auth_session(n1,n2)
	  session[:auth]=n1*n2
  end

  def redirect_to(options)
    if options.is_a? Hash
      options[:controller]="#{@metro_code}/#{options[:controller]}" if options[:controller]
    elsif options.is_a? String and options =~/^\//
      options="/#{@metro_code}#{options}"
    end
    super(options)
  end

  def redirect_to(options,*parameters_for_method_reference)
    controller.redirect(options,*parameters_for_method_reference)
  end

  def redirect_to(options)
    controller.redirect(options)
  end

  def metro_cache(hash, &block)
#    hash[:action]="#{@metro_code}_#{hash[:action]}"
#    hash[:skip_relative_url_root]=true
    cache(hash,&block)
  end



  def link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
    if options.is_a? Hash
      return super(name,options,html_options,*parameters_for_method_reference)
    elsif options.is_a? String and options =~/^\//
      options="/#{@metro_code}#{options}"
    else
      options="/#{@metro_code}/#{options}"
    end
    href= super(name,options,html_options,*parameters_for_method_reference)
    href
  end
end

#  def url_for(options = {}, *parameters_for_method_reference)
#    options[:controller]="#{@metro_code}/#{options[:controller]}" if options[:controller]
    
#    controller.url_for(options,*parameters_for_method_reference)
#  end

#  def form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
#  end
#  def start_form_tag (action,
#    <%:action=>'login'-%>
#    <%=text_field_tag(:name,"","size" => 7,
#		:value=>"",
#		:class=>"signup"
#		)%>
#   <%=password_field_tag(:password,"","size" => 7,
#		:id=>"password",
#		:class=>"signup"
#		)%>
#     <%= submit_tag 'Login' -%>&nbsp;
#   <%= end_form_tag-%>

