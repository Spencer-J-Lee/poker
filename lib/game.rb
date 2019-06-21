require_relative 'player'
require_relative 'deck'

class Game
	attr_reader :players, :current_player
	
	def initialize(*players)
		@players = players
		@current_player = players.first
	end
end