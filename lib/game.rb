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

	def round_over?
		players.one? { |player| !player.folded? }
	end
	
=begin
	def play
		until over?
			round = 1
			deal_cards

			until the round is over? (only one player isnt folded) || round == 4 (if the final round of betting already happened)
				if round.odd?
					until we have reached full rotation
						next_player! while current_player.folded? # cycle through players until we find one that hasn't folded
						betting_turn
						next_player!
					end
				else
					until we have reached full rotation
						next_player! while current_player.folded?
						discard_turn
						next_player!
					end
				end

				round += 1
			end

			determine the round winner(s)
			distribute the pot
			reset player hands and folded states
		end

		determine the game winner
	end
=end

	def next_player!
		@players.rotate!
		@current_player = players.first
	end

	def reset_players
		players.each do |player| 
			player.discard_hand!
			player.unfold
		end
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