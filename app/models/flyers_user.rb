# == Schema Information
#
# Table name: flyers_users
#
#  id           :integer          not null, primary key
#  user_id      :integer          default("0"), not null
#  flyer_id     :integer
#  created_at   :datetime         not null
#  deleted_flag :boolean          default("0")
#

class FlyersUser < ApplicationRecord

  has_one :flyer
  has_one :user
  
  def FlyersUser.users_for(flyer,include_author=true)
    return [] if !flyer or !flyer.user_id
    subselect = <<-SUBSELECT
      select * from flyers_users fu  where fu.flyer_id=#{flyer.id} and fu.deleted_at is null
    SUBSELECT
    subselect+=" and fu.user_id<>#{flyer.user_id} "
    fus = FlyersUser.find_by_sql(subselect)
    return [] unless fus.size>0
    user_ids = fus.collect {|fu|fu.user_id}.join(',')
    sql = <<-SQL
      select * from users where id in (#{user_ids})
    SQL
    User.find_by_sql(sql)
  end

  def FlyersUser.find_future_by_user(user) 
    sql = <<-SQL
      select fu.* from flyers_users fu, flyers f
      where f.id = fu.flyer_id
      and fu.deleted_at is null
      and fu.user_id=#{user.id}
    SQL
    find_by_sql(sql)
  end
end
