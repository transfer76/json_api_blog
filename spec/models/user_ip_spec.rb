require 'rails_helper'

RSpec.describe UserIp, type: :model do
  describe 'associations' do
    it { should have_many :posts }
    it { should have_many(:users).through(:posts) }
  end
end