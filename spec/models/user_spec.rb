# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  first_name             :string           default("")
#  last_name              :string           default("")
#  username               :string           default("")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  tokens                 :json
#  gender                 :integer
#  avatar                 :string
#  push_token             :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

require 'rails_helper'

describe User do
  describe 'Associations' do
    it { should have_many(:targets).dependent(:destroy)  }
    it { should have_many(:match_conversation_instances).dependent(:destroy)  }
  end

  describe 'validations' do
    subject { build :user }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }

    context 'when was created with facebook login' do
      subject { build :user, :with_fb }
      it { should_not validate_uniqueness_of(:email) }
      it { should_not validate_presence_of(:email) }
    end

    context 'when was created with regular login' do
      subject { build :user }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should validate_presence_of(:email) }
    end
  end

  context 'when was created with regular login' do
    let!(:user) { create(:user) }
    let(:full_name) { user.full_name }

    it 'returns the correct name' do
      expect(full_name).to eq(user.username)
    end
  end
end
