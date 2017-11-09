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

class Target < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  has_one :match_conversation_instance, dependent: :destroy

  validates :lng, :lat, :radius, :title, :user, :topic, presence: true
  validate :amount_of_targets, on: :create

  before_save :normalize_lonlat
  after_create :check_for_match

  scope :same_topic, -> (topic) { where(topic: topic) }
  scope :unmatched,  ->         { where(matched: false) }
  scope :by_date,     ->         { order(:id) }
  scope :matches, lambda { |lng, lat, radius, id, topic|
    where('ST_Intersects(ST_Buffer(targets.lonlat, targets.radius),
          ST_Buffer(ST_MakePoint(?, ?)::geography, ?))', lng, lat, radius)
      .where.not(id: id)
      .unmatched
      .same_topic(topic)
  }

  private

  def amount_of_targets
    limit = User::TARGET_AMOUNT_LIMIT
    errors.add(:targets_limit, "You reached the limit of targets created (#{limit})") if
      user.targets.count == limit
  end

  def normalize_lonlat
    self.lonlat = "POINT(#{lng} #{lat})" if position_changed?
  end

  def position_changed?
    lat_changed? || lng_changed?
  end

  def check_for_match
    targets = Target.matches(lng, lat, radius, id, topic)
    matched_target = targets.order(:id).first
    return unless matched_target.present?
    create_conversation(matched_target)
  end

  def create_conversation(matched_target)
    new_conversation = MatchConversation.create!(topic: topic)

    [self, matched_target].each do |target|
      target.update! matched: true
      MatchConversationInstance.create!(
        target: target,
        match_conversation: new_conversation,
        last_logout: Time.now)
    end
  end
end
