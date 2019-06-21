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

	def betting_turn
		action = current_player.get_action

		case action
		when 'raise'
			pot += current_player.get_raise_amount
		when 'fold'
			current_player.fold
		when 'see'
			display_pot
		end
	end

	def discard_turn
		amount = current_player.get_discard_amount
		current_player.discard(amount)
		amount.times { current_player.add_card(deck.draw) }
	end
end