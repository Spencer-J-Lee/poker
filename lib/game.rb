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

	def next_player!
		@players.rotate!
		@current_player = players.first
	end

	def deal_cards
		5.times { players.each { |player| player.add_card(deck.draw) } }
	end
end