class CreateCallsigns < ActiveRecord::Migration[5.1]
  def change
    create_table :callsigns do |t|
      t.string :spelling
      t.references :province, foreign_key: true
      t.boolean :isvalid

      t.timestamps
    end
    add_index :callsigns, :spelling, unique: true
  end
end
