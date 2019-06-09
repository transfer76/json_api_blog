class Post < ApplicationRecord
  belongs_to :user_ip
  belongs_to :user

  scope :top, -> (count) { order(rating: :desc).limit(count) }

  def rate!(new_rate)
    with_lock do
      new_count = rate_count + 1
      new_total = rate_total + new_rate

      update!(
        rate_count: new_count,
        rate_total: new_total,
        rating:     new_total.to_f / new_count
      )
    end
  end

  def serialize
    PostSerializer.new(self)
  end
end
