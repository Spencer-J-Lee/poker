require 'rspec'
require 'deck'
require 'Set'

describe Deck do
	subject(:deck) { Deck.new }

	it "holds a deck of 52 cards" do
		expect(deck.cards.all?(Card)).to be(true)
		expect(deck.cards.count).to eq(52)
	end

	it "holds a deck of all ranks" do
		deck_ranks = Set.new(deck.cards.map(&:rank))
		expect(deck_ranks.sort).to eq(Card.ranks.sort)
	end

	it "holds a deck with 4 copies of each rank" do
		ranks_count = deck.cards.group_by(&:rank)
		ranks_test  = ranks_count.values.all? { |value| value.count == 4 }
		expect(ranks_test).to be(true)
	end
	
	it "each rank has 4 different suits" do
		ranks_group = deck.cards.group_by(&:rank).values
		suits_test  = ranks_group.all? { |rank_group| rank_group.map(&:suit).uniq.count == 4 }
		expect(suits_test).to be(true)
	end

	describe "#draw" do
		it "returns the top card and removes it from the deck" do
			top_card = deck.cards.last
			expect(deck.cards.include?(top_card)).to be(true)
			expect(deck.draw).to be(top_card)
			expect(deck.cards.include?(top_card)).to be(false)
		end
	end

	describe "#reshuffle" do
		it "replace @cards with a new deck" do
			3.times { deck.draw }
			deck.reshuffle!
			expect(deck.cards.count).to eq(52)
		end
	end
end