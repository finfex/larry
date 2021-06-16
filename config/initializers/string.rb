class String
  # Convert numerics with comma
  def to_d
    BigDecimal.interpret_loosely self.tr(',','.')
  end
end
