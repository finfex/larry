class AddTypeToSiteSettings < ActiveRecord::Migration[6.1]
  def up
    add_column :site_settings, :value_type, :string, null: false, default: 'string'

    SiteSettings::SiteSetting.update_all value_type: 'text'
  end
end
