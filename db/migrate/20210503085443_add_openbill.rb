class AddOpenbill < ActiveRecord::Migration[6.1]
  DIR = Rails.root.join './vendor/openbill/sql/'

  def change
    Dir.entries(DIR).select{|f| File.file? DIR.join f }.sort.each do |file|
      say_with_time "Migrate with #{file}" do
        execute File.read DIR.join file
      end
    end
  end
end
