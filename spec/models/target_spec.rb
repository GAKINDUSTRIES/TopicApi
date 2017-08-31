require 'rails_helper'

describe Target do
  describe 'Associations' do
    it { should belong_to(:user)  }
    it { should belong_to(:topic)  }
  end

  describe 'Validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:topic) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lng) }
    it { should validate_presence_of(:radius) }
  end
end
