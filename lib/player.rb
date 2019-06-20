class Player
	attr_reader :hand, :pot

	def initialize
		@hand = Hand.new
		@pot  = 1000
	end
	
	def add_card(card)
		hand.add_card(card)
	end

	def fold

	end
	
	def see

	end
	
	def raise

	end
	
	def discard

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
