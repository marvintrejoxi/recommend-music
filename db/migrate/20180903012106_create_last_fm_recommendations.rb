class CreateLastFmRecommendations < ActiveRecord::Migration[5.2]
  def change
    create_table :last_fm_recommendations do |t|
      t.integer :watson_personality_id
      t.string :album_name
      t.string :album_url
      t.string :artist_name
      t.string :artist_url
      t.string :album_image
      t.string :genre
      t.timestamps
    end
  end
end
