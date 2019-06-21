require_relative 'player'
require_relative 'deck'

class Game
	attr_reader :players, :current_player, :deck, :pot

	def initialize(*players)
		@players        = players
		@current_player = players.first
		@deck           = Deck.new
		@pot            = 0
	end

	def over?
		players.one? { |player| !player.pot.zero? }
	end
end