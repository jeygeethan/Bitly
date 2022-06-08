class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.string :slug, null: false
      t.string :long_url, null: false

      t.timestamps
    end
  end
end
