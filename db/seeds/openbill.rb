if OpenbillAccount.count.zero?
  puts 'Initialize Openbill accounts'
  connection = OpenbillAccount.connection

  Settings.openbill.categories.each_pair do |name, id|
    OpenbillCategory.create_with(name: name).find_or_create_by!(id: id)
  end

  # connection.execute "INSERT INTO OPENBILL_ACCOUNTS (key, id, category_id, details, amount_currency) VALUES ('#{key}', '#{Billing::SYSTEM_ACCOUNTS[key]}', '#{Billing::SYSTEM_CATEGORY_ID}', '#{title}', '#{Money.default_currency.iso_code}')"
  # TODO Make specific policies
  OpenbillPolicy.find_or_create_by(name: 'Allow all')
end

