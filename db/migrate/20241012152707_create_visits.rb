class CreateVisits < ActiveRecord::Migration[7.2]
  def change
    create_table :visits do |t|
      t.references :url, null: false, foreign_key: true
      t.string :ip_address
      t.string :geolocation
      t.datetime :clicked_at

      t.timestamps
    end
  end
end
