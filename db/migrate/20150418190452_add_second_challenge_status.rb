class AddSecondChallengeStatus < ActiveRecord::Migration
  def change
    remove_column :challenges, :status
    add_column :challenges, :sender_status, :string
    add_column :challenges, :receiver_status, :string
  end
end
