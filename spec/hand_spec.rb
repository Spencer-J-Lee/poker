require 'rspec'
require 'hand'

describe Hand do 
	subject(:hand) { Hand.new }
	let(:card) { double("card", rank: :ace, suit: :spade, value: 14) }

	it "initializes an empty hand" do
		expect(hand.cards).to be_empty
	end

	describe "#add_card" do
		it "adds a card to the hand" do
			hand.add_card(card)
			expect(hand.cards.include?(card)).to be(true)
		end

		it "raises exception if hand already has 5 cards" do
			5.times { hand.add_card(card) }
			expect { hand.add_card(card) }.to raise_error
		end
	end
end