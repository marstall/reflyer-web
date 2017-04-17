# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer          default(0), not null
#  created_at :datetime
#  flyer_id   :integer          default(0), not null
#

class Tagging < ApplicationRecord

  belongs_to :tag
  has_one :flyer
end
