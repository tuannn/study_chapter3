class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :request_from_id
      t.integer :request_to_id
      t.boolean :status, defaul: false

      t.timestamps
    end
	add_index :friends, :request_from_id
	add_index :friends, :request_to_id
	
	add_index :friends, [:request_from_id, :request_to_id], unique: true
  end
end
