class DurationIsInteger < ActiveRecord::Migration
  def change
    change_column :single_player_games, :duration, :integer
    change_column :multi_player_games, :duration, :integer
  end
end
