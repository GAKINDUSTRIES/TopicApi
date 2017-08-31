# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  label      :string           not null
#  icon       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Topic < ApplicationRecord
  mount_uploader :icon, IconUploader

  has_many :targets, dependent: :destroy

  validates :label, presence: true

  # Method to correctly display topics in ActiveAdmin
  def display_name
    label
  end
end
