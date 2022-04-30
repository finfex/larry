class SiteUnknown < StandardError
  def message
    'Ошибка. Не правильный адрес сайта'
  end
end
