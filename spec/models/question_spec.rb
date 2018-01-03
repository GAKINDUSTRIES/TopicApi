# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  body       :text
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Question do
  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:email) }
  end
end
