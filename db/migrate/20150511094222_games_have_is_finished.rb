class GamesHaveIsFinished < ActiveRecord::Migration
  def change
    rename_column :single_player_games, :is_victory, :is_finished
    add_column :multi_player_games, :is_finished, :boolean
  end
end
