class CreateSinglePlayerGames < ActiveRecord::Migration
  def change
    create_table :single_player_games do |t|
      t.string :from
      t.string :to
      t.references :user

      t.timestamps
    end
    add_index :single_player_games, :user_id
  end
end
