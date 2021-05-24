module NotyFlashHelper
  DEFAULT_TYPE = :warning
  TYPES = { alert: :error, notice: :info }

  def noty_flashes
    flash.map do |key, value|
      javascript_tag(noty_flash_javascript(key, value))
    end.join.html_safe
  end

  def noty_flash_javascript(key, message)
    method = TYPES.fetch(key.to_sym, DEFAULT_TYPE)

    "window.Flash.#{method}(#{message.to_json})"
  end
end
