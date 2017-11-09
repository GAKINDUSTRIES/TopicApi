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
#  lonlat     :geography({:srid not null, point, 4326
#  matched    :boolean          default("false")
#
# Indexes
#
#  index_targets_on_lonlat    (lonlat)
#  index_targets_on_matched   (matched)
#  index_targets_on_topic_id  (topic_id)
#  index_targets_on_user_id   (user_id)
#

FactoryGirl.define do
  factory :target do
    user
    topic
    title   { Faker::Name.title }
    lat     { Faker::Number.decimal(2, 6) }
    lng     { Faker::Number.decimal(2, 6) }
    radius  { Faker::Number.number(7) }
  end
end
