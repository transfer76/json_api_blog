class User < ApplicationRecord
  has_many :posts
  has_many :user_ips, through: :posts
end
