class User < ActiveRecord::Base
  attr_accessible :email, :pseudo, :password, :password_confirmation, :remember_me, :new_password, :new_password_confirmation
  has_many :single_player_games
  
  attr_accessor :password, :remember_me, :new_password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_confirmation_of :new_password, :if => Proc.new {|user| !user.new_password.nil? && !user.new_password.empty? }
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_uniqueness_of :pseudo
  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  
  def singleplayer_games
    self.single_player_games.sort_by { |h| h[:created_at] }.reverse
  end

  # ========= Account Statistics ==========

  def singleplayer_victories_nb
    self.single_player_games.where(is_victory: true).count
  end

  def singleplayer_games_nb
    self.single_player_games.count
  end

  def average_victory_duration
    total_durations = 0
    for game in self.single_player_games.where(is_victory: true)
      total_durations = total_durations + game.duration
    end
    victories_nb = self.single_player_games.where(is_victory: true).count
    format("%.2f",total_durations.to_f / victories_nb)
  end

  def victories_rate
    total = self.single_player_games.count
    victories = self.single_player_games.where(is_victory: true).count
    if total > 0
      victories.to_f / total
    else
      -1
    end
  end

  # ========= Account Authentication ==========

  def self.authenticate_by_email(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def self.authenticate_by_pseudo(pseudo, password)
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