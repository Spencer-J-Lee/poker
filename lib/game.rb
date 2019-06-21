require_relative 'player'
require_relative 'deck'

class PokerGame
	attr_reader :players, :current_player, :round, :deck, :pot

	def initialize(*players)
		@players        = players
		@current_player = players.first
		@round          = nil
		@deck           = Deck.new
		@pot            = 0
	end

	def play
		until over?
			@round = 1
			deal_cards

			until round_over?
				if round.odd?
					2.times do
						system 'clear'
						next_player! while current_player.folded? # cycle through players until we find one that hasn't folded
						
						puts  "#{current_player.name}'s turn"
						puts
						puts  "Current pot: #{pot}"
						puts  "Wallet:      #{current_player.pot}"
						print "Hand:        #{current_player.hand.cards}"
						puts
						puts
						betting_turn

						next_player!
						puts "-----------"
					end
				else
					2.times do
						system 'clear'
						next_player! while current_player.folded?

						puts  "#{current_player.name}'s turn"
						puts
						puts  "Current pot: #{pot}"
						puts  "Wallet:      #{current_player.pot}"
						print "Hand:        #{current_player.hand.cards}"
						puts
						puts
						discard_turn

						next_player!
						puts "-----------"
					end
				end

				@round += 1
			end

			system 'clear'
			round_winners.each { |player| print player.name + " " }
			puts "wins the round!"
			puts
			gets

			distribute_pot
			reset_players
		end

		
		system 'clear'
		puts "The winner is: #{game_winner.name}"
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
		puts "Choose: raise / fold / see"
		action = current_player.get_action

		case action
		when 'raise'
			puts "How much to raise?"
			@pot += current_player.get_raise_amount
		when 'fold'
			current_player.fold
		when 'see'
			display_pot
		end
	end

	def discard_turn
		puts "How many cards to discard? (0 to 3)"
		amount = current_player.get_discard_amount

		puts "Which cards to discard?"
		current_player.discard(amount)
		amount.times { current_player.add_card(deck.draw) }
		print "New hand: #{current_player.hand.cards}"
		puts
		gets
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
	game = PokerGame.new(Player.new('P1'), Player.new('P2'))
	game.play
end