FactoryBot.define do
  factory :user_ip do
    ip { Faker::Internet.ip_v4_address }
  end
end