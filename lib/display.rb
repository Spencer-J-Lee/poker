class Display
	attr_reader :game, :players

	def initialize(game)
		@game = game
	end

	def input_arrow
		print "> "
	end

	def continue_prompt
		puts
		puts "Press enter to continue"
		gets
	end

	def clear
		system 'clear'
	end

	def turn_UI
		clear

		puts  "#{game.current_player.name}'s turn"
		puts
		puts  "Current pot: #{game.pot}"
		puts  "Wallet:      #{game.current_player.pot}"
		print "Hand:        #{game.current_player.hand.cards}"
		puts
		puts
	end

	def round_end_UI
		clear
		
		game.players.each { |player| p "#{player.name}'s hand: #{player.hand.cards}" }
		
		winner_names = game.round_winners.map(&:name)
		puts "#{winner_names.join(" ")} wins the round!"
		
		continue_prompt
	end

	def action_prompt_UI
		puts "Choose: raise / fold"
		input_arrow
	end

	def raise_prompt_UI
		puts "How much would you like to raise?"
		input_arrow
	end

	def discard_amt_prompt_UI
		puts "How many cards would you like to discard? (0 to 3)"
		input_arrow
	end

	def discard_which_prompt_UI
		puts "Which cards which you like to discard?"
		input_arrow
	end

	def new_hand_UI
		print "New hand: #{game.current_player.hand.cards} \n"
		input_arrow
	end

	def winner_announcement_UI
		puts "#{game.game_winner.name} wins the game!"
	end
end