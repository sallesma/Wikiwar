class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.references :sender
      t.references :receiver
      t.string :locale
      t.string :status

      t.timestamps
    end
    add_index :challenges, :sender_id
    add_index :challenges, :receiver_id
  end
end
