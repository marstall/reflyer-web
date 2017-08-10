# == Schema Information
#
# Table name: taggings
#
#  tag_id     :integer          default(0), not null
#  created_at :datetime         default(NULL), not null
#  flyer_id   :integer          default(0), not null
#  id         :integer          not null, primary key
#

class Tagging < ApplicationRecord

  belongs_to :tag
  has_one :flyer
end
