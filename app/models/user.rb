class User < ActiveRecord::Base
  attr_accessible :email, :pseudo, :password, :password_confirmation, :remember_me, :new_password, :new_password_confirmation
  has_many :single_player_games
  has_many :challenges_sent, :class_name => "Challenge", :foreign_key => "sender_id"
  has_many :challenges_received, :class_name => "Challenge", :foreign_key => "receiver_id"
  
  attr_accessor :password, :remember_me, :new_password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_confirmation_of :new_password, :if => Proc.new {|user| !user.new_password.nil? && !user.new_password.empty? }
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_presence_of :pseudo
  validates_uniqueness_of :email
  validates_uniqueness_of :pseudo
  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  
  include Gravtastic
  gravtastic

  # ========= Account SinglePlayerGames ==========

  def singleplayer_games
    self.single_player_games.sort_by { |h| h[:created_at] }.reverse
  end

  def singleplayer_games_finished
    self.single_player_games.where(is_finished: true).sort_by { |h| h[:created_at] }.reverse
  end

  def singleplayer_games_playing
    self.single_player_games.where(is_finished: [false, nil]).sort_by { |h| h[:created_at] }.reverse
  end

  # ========= Account Challenges ==========

  def challenges_received_pending
    self.challenges_received.where("receiver_status = 'pending'").sort_by { |h| h[:updated_at] }.reverse
  end

  def challenges_notification
    self.challenges_received_pending.concat(challenges_accepted).concat(challenges_playing).sort_by { |h| h[:updated_at] }.reverse
  end

  def challenges_sent_pending_or_accepted
    self.challenges_sent.where("receiver_status = 'pending' OR (sender_status = 'accepted' AND receiver_status = 'accepted')").sort_by { |h| h[:updated_at] }.reverse
  end

  def challenges_accepted
    self.challenges_received.where("receiver_status = 'accepted'").concat(self.challenges_sent.where("sender_status = 'accepted'")).sort_by { |h| h[:updated_at] }.reverse
  end

  def challenges_playing
    self.challenges_received.where("receiver_status = 'playing'").concat(self.challenges_sent.where("sender_status = 'playing'")).sort_by { |h| h[:updated_at] }.reverse
  end

  def challenges_finished
    condition = "(receiver_status = 'finished' OR receiver_status = 'withdrawn' ) AND (sender_status = 'finished' OR sender_status = 'withdrawn')"
    self.challenges_received.where(condition).concat(self.challenges_sent.where(condition)).sort_by { |h| h[:updated_at] }.reverse
  end

  def challenges_won
    finished = self.challenges_finished.select{|challenge| challenge.winner == self}
  end

  def challenges_victory_rate
    total = self.challenges_finished.count
    victories = self.challenges_won.count
    if total > 0
      victories.to_f / total
    else
      -1
    end
  end

  # ========= Account Statistics ==========

  def singleplayer_victories_nb
    self.single_player_games.where(is_finished: true).count
  end

  def singleplayer_games_nb
    self.single_player_games.count
  end

  def singleplayer_average_victory_duration
    total_durations = 0
    for game in self.single_player_games.where(is_finished: true)
      total_durations = total_durations + game.duration
    end
    victories_nb = self.single_player_games.where(is_finished: true).count
    if victories_nb > 0
      total_durations.to_f / victories_nb
    else
      -1
    end
  end

  def singleplayer_victories_rate
    total = self.single_player_games.count
    victories = self.single_player_games.where(is_finished: true).count
    if total > 0
      victories.to_f / total
    else
      -1
    end
  end

  # ========= Account Authentication ==========
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end