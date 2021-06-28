FactoryBot.define do
  factory :order_action do
    order { nil }
    message { "MyString" }
    operator { nil }
  end
end
