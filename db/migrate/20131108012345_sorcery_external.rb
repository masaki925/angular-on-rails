class SorceryExternal < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id,       null: false
      t.string :provider, :uid, null: false
      t.string :access_token
      t.string :permissions,    limit: 1000

      t.timestamps
    end
  end
end
