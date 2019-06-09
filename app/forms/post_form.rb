class PostForm < Reform::Form
  include Composition

  property :title, on: :post
  property :body, on: :post
  property :username, on: :user
  property :ip, on: :user_ip

  validates :title, :body, :username, :ip, presence: true

  def initialize(options = {})
    super(
      post:    Post.new(title: options[:title], body: options[:body]),
      user:    User.find_or_initialize_by(username: options[:username]),
      user_ip: UserIp.find_or_initialize_by(ip: options[:ip])
    )
  end

  def post
    model[:post]
  end

  def user
    model[:user]
  end

  def user_ip
    model[:user_ip]
  end

  def save
    return false unless valid?

    ::ActiveRecord::Base.transaction do
      user_ip.save!
      user.save!

      post.assign_attributes(
        user: user,
        user_ip: user_ip,
      )

      post.save!
    end
  end
end