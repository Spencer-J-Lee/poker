require_relative 'card'

class Deck
	attr_reader :cards

	def self.shuffled_deck
		deck = []
		
		Card.ranks.each do |rank|
			Card.suits.each { |suit| deck << Card.new(rank, suit) }
		end
		
		deck.shuffle
	end

	def initialize
		@cards = Deck.shuffled_deck
	end

	def draw
		@cards.pop
	end

	def reshuffle!
		@cards = Deck.shuffled_deck
	end
end