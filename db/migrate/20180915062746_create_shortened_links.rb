class CreateShortenedLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :shortened_links do |t|
      t.string :name, :null => false
      t.string :original_url, :null => false
      t.string :unique_key, :null => false
      t.string :shortened_url, :null => false
      t.integer :hit_count, :null => false, :default => 0

      t.timestamps
    end
  end
end
