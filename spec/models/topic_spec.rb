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

require 'rails_helper'

describe Topic do
  describe 'Associations' do
    it { should have_many(:targets).dependent(:destroy)  }
  end

  describe 'Validations' do
    it { should validate_presence_of(:label) }
  end

  describe '#display_name' do
    let(:topic) { create :topic }

    it 'displays the label as the default display_name' do
      expect(topic.display_name).to eq topic.label
    end
  end
end
