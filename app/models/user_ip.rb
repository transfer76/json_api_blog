class UserIp < ApplicationRecord
  has_many :posts
  has_many :users, through: :posts

  scope :groups, -> {
    joins(:users).group('user_ips_id').order('count(user_ip_id) DESC').having('count(user_ip_id) > 1')
  }

  def serialize
    UserIpSerializer.new(self)
  end
end
