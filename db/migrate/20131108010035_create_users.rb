class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :username,         index: true
      t.string   :email,            null: false
      t.string   :crypted_password, default: nil
      t.string   :salt,             default: nil
      t.datetime :last_login_at
      t.datetime :last_logout_at
      t.datetime :last_activity_at
      t.string   :last_login_from_ip_address
      t.string   :name
      t.string   :first_name
      t.string   :last_name
      t.date     :birthday
      t.string   :locale
      t.text     :introduction
      t.string   :gender
      t.string   :education
      t.string   :country_code,               index: true
      t.string   :work
      t.datetime :deleted_at,                 index: true
      t.string   :crypted_password
      t.string   :salt
      t.string   :image_url,                  limit: 2000
      t.boolean  :age_is_public,              default: true,  null: false
      t.boolean  :official_account,           default: false, null: false

      t.timestamps
    end
  end
end
