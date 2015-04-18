class CreateMultiPlayerGames < ActiveRecord::Migration
  def change
    create_table :multi_player_games do |t|
      t.string :from
      t.string :to
      t.string :locale
      t.datetime :duration
      t.integer :steps

      t.timestamps
    end

    add_column :challenges, :sender_game_id, :integer
    add_column :challenges, :receiver_game_id, :integer
    add_index :challenges, :sender_game_id
    add_index :challenges, :receiver_game_id

    remove_column :articles, :single_player_game_id, :integer
    add_column :articles, :game_id, :integer
    add_column :articles, :game_type, :string
  end
end
