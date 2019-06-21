require_relative 'player'
require_relative 'deck'
require_relative 'display'

class PokerGame
	attr_reader :players, :current_player, :round, :deck, :pot, :display

	def initialize(*players)
		@players        = players
		@current_player = players.first
		@round          = nil
		@deck           = Deck.new
		@pot            = 0
		@display        = Display.new(self)
	end

	def play
		until over?
			@round = 1
			deal_cards

			until round_over?
				not_folded_count = players.count { |player| !player.folded? }

				not_folded_count.times do
					next_player! while current_player.folded?

					display.turn_UI

					if round.odd?
						betting_turn
						next_player!
					else
						discard_turn
						next_player!
					end

					break if over_by_fold?
				end

				@round += 1
			end

			display.round_end_UI

			distribute_pot
			reset_players
		end

		display.winner_announcement_UI
	end

	def over?
		players.one? { |player| !player.pot.zero? }
	end

	def round_over?
		over_by_fold? || over_by_round?
	end

	def over_by_fold?
		players.one? { |player| !player.folded? }
	end

	def over_by_round?
		@round == 4
	end

	def game_winner
		players.find { |player| !player.pot.zero? }
	end
	
	def round_winners
		over_by_fold? ? [find_winner_by_fold] : find_winners_by_hand
	end

	def find_winner_by_fold
		players.find { |player| !player.folded? }
	end

	def find_winners_by_hand
		# returns a 2D-array of the players' scores with the last element being the player's themselves
		scoreboard = players.map { |player| player.score << player }

		# iterates through each player's score and compares scores by index
		# scores with numbers at the current index that are lower than the current max are rejected
		# stops before reaching the actual player in the score array
		6.times do |i|
			decisive_scores = scoreboard.map { |score| score[i] }
			scoreboard      = scoreboard.reject { |score| score[i] != decisive_scores.max }
		end

		# returns all players who have winning hands
		round_winners = scoreboard.map(&:last)
	end

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
		display.action_prompt_UI

		action = current_player.get_action

		case action
		when 'raise'
			display.raise_prompt_UI
			@pot += current_player.get_raise_amount
		when 'fold'
			current_player.fold
		end
	end

	def discard_turn
		display.discard_amt_prompt_UI
		
		amount = current_player.get_discard_amount

		if amount > 0
			display.discard_which_prompt_UI

			current_player.discard(amount)
			amount.times { current_player.add_card(deck.draw) }

			display.new_hand_UI
		end
	end

	def distribute_pot
		winners = self.round_winners
		distribute_amt = pot / winners.count.to_f

		winners.each do |player|
			player.add_to_pot(distribute_amt)
			@pot -= distribute_amt
		end
	end
end

if __FILE__ == $PROGRAM_NAME
	system 'clear'
	game = PokerGame.new(Player.new('P1'), Player.new('P2'), Player.new('P3'))
	game.play
end