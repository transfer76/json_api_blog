class UserIpSerializer < ActiveModel::Serializer
  attributes :ip, :users

  def users
    object.users.uniq.map(&:username)
  end
end