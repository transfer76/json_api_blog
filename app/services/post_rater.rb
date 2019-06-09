class PostRater < Polist::Service
  class Form < Polist::Service::Form
    attribute :rate, :Integer
    attribute :post

    validates :rate, numericality: {
                       only_integer: true,
                       greater_than_or_equal_to: 1,
                       less_than_or_equal_to: 5
    }
  end

  def call
    if form.valid?
      post = form.post
      post.rate!(form.rate)

      success!(post)
    else
      fail!(form)
    end
  end
end