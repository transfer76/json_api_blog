POST_COUNT = 250_000
USER_COUNT = 120
IP_ADDRESS_COUNT = 60

bar = ProgressBar.new(POST_COUNT)

usernames = []
USER_COUNT.times { usernames << Faker::Internet.unique.username }

ip_addresses = []
IP_ADDRESS_COUNT.times { ip_addresses << Faker::Internet.unique.ip_v4_address }

usernames_with_ips = usernames.map { |u| { username: u, ip: ip_addresses.sample(rand(1..5)) } }

puts "Creating #{POST_COUNT} posts..."

ActiveRecord::Base.transaction do
  POST_COUNT.times do |i|
    user = usernames_with_ips.sample
    username = user[:username]
    ip = user[:ip].sample

    body = Faker::Lorem.paragraphs(5).join("\n")
    title = Faker::Lorem.sentence

    post_form = PostForm.new(
        username: username,
        title: title,
        body: body,
        ip: ip
    )

    post_form.save

    if rand(100).zero?
      post = post_form.post
      rand(1..50).times do
        rate = rand(1..5)
        PostRater.call(post: post, rate: rate)
      end
    end

    bar.increment!
  end
end