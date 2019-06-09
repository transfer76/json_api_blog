class Post < ApplicationRecord
  belongs_to :user_ip
  belongs_to :user

  def serialize
    PostSerializer.new(self)
  end
end
