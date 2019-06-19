class Hand
	attr_reader :cards

	def initialize
		@cards = []
	end

	def add_card(card)
		raise ArgumentError "Hand already has 5 cards" if @cards.count >= 5
		@cards << card
	end
end