class WalletActivity < ApplicationRecord
  belongs_to :wallet
  belongs_to :opposit_account
  belongs_to :author
end
