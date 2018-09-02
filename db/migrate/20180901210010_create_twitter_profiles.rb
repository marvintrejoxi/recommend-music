class CreateTwitterProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :twitter_profiles do |t|
      t.string :name
      t.string :username
      t.string :user_id
      t.string :location
      t.string :language
      t.string :image_path
      t.string :description
      t.timestamps
    end
  end
end
