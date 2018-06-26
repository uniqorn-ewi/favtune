class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.text :avatar
      t.boolean :status

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
