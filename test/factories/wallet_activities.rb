FactoryBot.define do
  factory :wallet_activity do
    wallet { nil }
    amount { "" }
    opposit_account { nil }
    details { "MyString" }
    author { nil }
  end
end
