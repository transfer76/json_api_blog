FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraphs(5).join("\n") }
    rate_total { 10 }
    rate_count { 2 }
    rating { rate_total.to_f / rate_count }
    
    association :user
    association :user_ip
  end
end