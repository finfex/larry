FactoryBot.define do
  factory :wallet do
    payment_system { nil }
    amount { '' }
    details { 'MyText' }
  end
end
