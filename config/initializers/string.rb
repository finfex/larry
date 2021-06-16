# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class String
  # Convert numerics with comma
  def to_d
    BigDecimal.interpret_loosely tr(',', '.')
  end
end
