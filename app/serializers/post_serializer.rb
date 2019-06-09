class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :rating, :username, :ip

  def ip
    object.user_ip.ip
  end

  def username
    object.user.username
  end
end
