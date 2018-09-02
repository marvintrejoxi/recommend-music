class CreateWatsonPersonalities < ActiveRecord::Migration[5.2]
  def change
    create_table :watson_personalities do |t|
      t.string :name
      t.string :category
      t.decimal :percentage
      t.string :trait_id
      t.decimal :score
      t.boolean :significant
      t.integer :twitter_profile_id
      t.timestamps
    end
  end
end
