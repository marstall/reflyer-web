# == Schema Information
#
# Table name: push_notifications
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  body           :text(65535)
#  pushed_at      :datetime
#  recipient_type :string(255)
#  place_id       :integer
#  category       :string(255)
#  user_id        :integer
#  response_code  :string(255)
#  response_json  :text(65535)
#  error_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  success_count  :integer
#

class PushNotification < ActiveRecord::Base

  RECIPIENT_TYPE_ALL='all'
  RECIPIENT_TYPE_SINGLE='single'
  
  #validates_presence_of :recipient_type, :body
  #validate :recipient_type_single_must_have_user_id
  
  expo_push_tokens=nil
  
  def recipient_type_single_must_have_user_id
    if recipient_type==RECIPIENT_TYPE_SINGLE && !user_id
      errors.add("must specify user_id for 'single' type push notification")
    end
  end
  
  def PushNotification.create(recipient_type,recipient_identifier=nil)
    push_notification = PushNotification.new
    push_notification.recipient_type = recipient_type
    case recipient_type
    when RECIPIENT_TYPE_SINGLE
      push_notification.user_id=recipient_identifier
    end
    return push_notification
  end
  
  def PushNotification.single_user(user_id,body)
    pn = PushNotification.create(RECIPIENT_TYPE_SINGLE,user_id)
    pn.body=body
    pn.send_push
  end

  def PushNotification.all_users(title,body)
    pn = PushNotification.create(RECIPIENT_TYPE_ALL)
    pn.title=title
    pn.body=body
    pn.send_push
  end

  def send_push
    if !valid?
      puts "fatal errors:"
      errors.each{|error|
        puts error
      }
      return
    end
    
    case recipient_type
    when RECIPIENT_TYPE_SINGLE
      send_to_single_user
    when RECIPIENT_TYPE_ALL
      send_to_all_users
    end
  end
  
  def send_to_single_user
    puts "sending push to single user #{user_id} ..."
    user = User.find(user_id)
    puts "can't find user" and return unless user
    @expo_push_tokens = [user.expo_push_token]
    actually_send_push_notifications
  end
  
  def send_to_all_users
    num_users = User.where.not(expo_push_token:nil).where.not(expo_push_token:"null").where(notifications_permission_state:"accepted").count
    puts "sending push to all #{num_users} users ..."
    page_size=100
    offset = 0
    loop do 
      users = User.where.not(expo_push_token:nil).where.not(expo_push_token:"null").where(notifications_permission_state:"accepted").limit(page_size).offset(offset)
      puts "sending push to #{offset}-#{page_size+offset} / #{users.length} users ..."
      @expo_push_tokens = users.map{|user|user.expo_push_token}
      actually_send_push_notifications
      break if offset>num_users
    end
  end
  
  def actually_send_push_notifications
    messages = @expo_push_tokens.map{|expo_push_token|
       obj = {
        to: expo_push_token,
        body: body
      }
      obj["title"]=title if title
      obj
    }
    puts "input: #{messages.inspect}"
    response = Exponent.publish messages
    save_response(response)
  end
  
  def save_response(response)
    self.pushed_at=Time.now
    self.response_json= response.body
    if (self.response_json['errors']) 
      puts "fatal error!"
      puts response_json
      puts "did not send any push notifications."
      return
    end
    self.response_code= response.code
    puts "Expo server responded with a #{response_code}."
    self.success_count=0
    self.error_count=0
    puts response_json
    JSON.parse(response_json)['data'].each_with_index{|item,i|
      if item['status']=='ok'
        self.success_count+=1
      else
        self.error_count+=1
        puts "failed: #{@expo_push_tokens[i]}"
      end
    }
    puts "successes: #{self.success_count}"
    puts "failures: #{self.error_count}"
    self.save
  end

end
