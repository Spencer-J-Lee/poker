class Player
	attr_reader :hand, :pot
	
	def initialize
		@hand = Hand.new
		@pot  = 1000
	end
end

=begin

Rules
Each player is dealt five cards.
Players bet; each player may fold, see the current bet, or raise.
In turn, each player can choose to discard up to three cards.
They are dealt new cards from the deck to replace their old cards.
Players bet again.
If any players do not fold, then players reveal their hands; strongest hand wins the pot.

Player
Each player has a hand, plus a pot
Player has methods to ask the user:
Which cards they wish to discard
Whether they wish to fold, see, or raise.

=end