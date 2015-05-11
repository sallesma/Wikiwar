class AddDateInfoFields < ActiveRecord::Migration
  def change
    add_column :users, :signed_up_on, :datetime
    add_column :users, :last_signed_in_on, :datetime
  end
end
