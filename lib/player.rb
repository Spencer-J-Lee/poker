class Player
	attr_reader :hand, :pot, :folded

	def initialize
		@hand   = Hand.new
		@pot    = 1000
		@folded = false
	end

	def fold
		@folded = true
	end
	
	def unfold
		@folded = false
	end
	
	def folded?
		@folded
	end

	def add_card(card)
		hand.add_card(card)
	end

	def discard(amount)
		discarded = 0

		until discarded == amount
			card_index = get_card_index
			hand.discard_at(card_index)
			discarded += 1
		end

		nil
	end

	def discard_hand!
		@hand.discard!
	end

	def get_card_index
		card_index = $stdin.gets.to_i
		card_index = $stdin.gets.to_i until card_index.between?(0,4)
		card_index
	end

	def get_discard_amount
		discard_amount = $stdin.gets.to_i
		discard_amount = $stdin.gets.to_i until discard_amount.between?(0,3)
		discard_amount
	end

	def get_raise_amount
		raise_amount = $stdin.gets.to_i
		raise_amount = $stdin.gets.to_i until raise_amount.between?(1,pot)
		@pot -= raise_amount
		raise_amount
	end

	def get_action
		action = $stdin.gets.chomp 
		action = $stdin.gets.chomp until %w(fold see raise).include?(action)
		action
	end
end

=begin

1. Each player has a hand, plus a pot
2. Player has methods to ask the user:
	3. Which cards they wish to discard
	4. Whether they wish to fold, see, or raise.

Each player is dealt five cards.
Players bet; each player may fold, see the current bet, or raise.
In turn, each player can choose to discard up to three cards.
They are dealt new cards from the deck to replace their old cards.
Players bet again.
If any players do not fold, then players reveal their hands; strongest hand wins the pot.

=end
