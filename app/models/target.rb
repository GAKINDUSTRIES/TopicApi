# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  lat        :float            not null
#  lng        :float            not null
#  radius     :float            not null
#  topic_id   :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_targets_on_topic_id  (topic_id)
#  index_targets_on_user_id   (user_id)
#

class Target < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  validates :lat, :lng, :radius, presence: true
end
