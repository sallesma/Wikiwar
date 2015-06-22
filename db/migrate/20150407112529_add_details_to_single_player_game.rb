class AddDetailsToSinglePlayerGame < ActiveRecord::Migration
  def change
    add_column :single_player_games, :is_victory, :boolean
    add_column :single_player_games, :duration, :timestamp
    add_column :single_player_games, :steps, :integer
  end
end
