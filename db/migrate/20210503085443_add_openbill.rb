# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class AddOpenbill < ActiveRecord::Migration[6.1]
  DIR = Rails.root.join './vendor/openbill/sql/'

  def change
    Dir.entries(DIR).select { |f| File.file? DIR.join f }.sort.each do |file|
      say_with_time "Migrate with #{file}" do
        execute File.read DIR.join file
      end
    end

    add_reference :openbill_accounts, :reference, polymorphic: true
  end
end
