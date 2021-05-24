class ApplicationCommand
  def self.call(args)
    new.call(**args)
  end
end
