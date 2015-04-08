class User < ActiveRecord::Base
  attr_accessible :email, :pseudo, :password, :password_confirmation
  has_many :single_player_games
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_uniqueness_of :pseudo
  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  
  def singleplayer_games
    games = self.single_player_games.sort_by { |h| h[:created_at] }.reverse
  end

  def singleplayer_victories_nb
    self.single_player_games.where(is_victory: true).count
  end

  def singleplayer_games_nb
    self.single_player_games.count
  end

  def victories_rate
    total = self.single_player_games.count
    victories = self.single_player_games.where(is_victory: true).count
    format("%.2f",victories.to_f / total)
  end

  def self.authenticate(pseudo, password)
    user = find_by_pseudo(pseudo)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end