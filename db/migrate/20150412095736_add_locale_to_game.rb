class AddLocaleToGame < ActiveRecord::Migration
  def change
    add_column :single_player_games, :locale, :string
  end
end
