class PaymentSystemLogoUploader < ApplicationUploader
  def extension_white_list
    %w(jpg jpeg gif png svg)
  end

  def default_url(*args)
    "/images/fallback/" + [version_name, "payment_system.png"].compact.join('_')
  end
end
