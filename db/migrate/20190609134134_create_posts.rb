class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :rate_total, default: 0
      t.integer :rate_count, default: 0
      t.float :rating, default: 0.0
      t.references :user_ip, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps

      t.index [:user_ip_id, :user_id]
      t.index [:user_id, :user_ip_id]
    end
  end
end
