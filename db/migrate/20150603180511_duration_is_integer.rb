class DurationIsInteger < ActiveRecord::Migration
  def change
    change_column :single_player_games, :duration, 'integer USING CAST(extract(epoch from duration) AS integer)'
    change_column :multi_player_games, :duration, 'integer USING CAST(extract(epoch from duration) AS integer)'
  end
end
