require 'rspec'
require 'hand'

describe Hand do 
	subject(:hand) { Hand.new }
	let(:aceS  ) { double("card", rank: :ace,   suit: :spades,   value: 14) }
	let(:aceH  ) { double("card", rank: :ace,   suit: :hearts,   value: 14) }
	let(:aceD  ) { double("card", rank: :ace,   suit: :diamonds, value: 14) }
	let(:aceC  ) { double("card", rank: :ace,   suit: :clubs,    value: 14) }
	let(:kingS ) { double("card", rank: :king,  suit: :spades,   value: 13) }
	let(:queenS) { double("card", rank: :queen, suit: :spades,   value: 12) }
	let(:jackS ) { double("card", rank: :jack,  suit: :spades,   value: 11) }
	let(:tenS  ) { double("card", rank: :ten,   suit: :spades,   value: 10) }
	let(:nineS ) { double("card", rank: :nine,  suit: :spades,   value: 10) }
	let(:nineH ) { double("card", rank: :nine,  suit: :hearts,   value: 10) }

	let(:royal_flush) do
		[aceS,kingS,queenS,jackS,tenS].each { |card| hand.add_card(card) }
		hand
	end

	let(:straight_flush) do
		[kingS,queenS,jackS,tenS,nineS].each { |card| hand.add_card(card) }
		hand
	end

	let(:four_of_a_kind) do
		[aceS,aceH,aceD,aceC,nineH].each { |card| hand.add_card(card) }
		hand
	end

	let(:full_house) do
		[aceS,aceH,aceD,nineS,nineH].each { |card| hand.add_card(card) }
		hand
	end

	let(:flush) do
		[aceS,kingS,queenS,jackS,nineS].each { |card| hand.add_card(card) }
		hand
	end

	let(:straight) do
		[kingS,queenS,jackS,tenS,nineH].each { |card| hand.add_card(card) }
		hand
	end

	let(:three_of_a_kind) do
		[aceS,aceH,aceD,tenS,nineS].each { |card| hand.add_card(card) }
		hand
	end

	let(:two_pair) do
		[aceS,aceH,kingS,kingH,nineS].each { |card| hand.add_card(card) }
		hand
	end

	let(:one_pair) do
		[aceS,aceH,queenS,jackS,tenS].each { |card| hand.add_card(card) }
		hand
	end

	it "initializes an empty hand" do
		expect(hand.cards).to be_empty
	end

	describe "#add_card" do
		it "adds a card to the hand" do
			hand.add_card(aceS)
			expect(hand.cards.include?(aceS)).to be(true)
		end

		it "raises exception if hand already has 5 cards" do
			5.times { hand.add_card(aceS) }
			expect { hand.add_card(aceS) }.to raise_error(ArgumentError)
		end
	end

	describe "#values" do
		it "returns the hand mapped to each card's value" do
			[aceS,kingS,queenS,jackS,tenS].each { |card| hand.add_card(card) }
			expect(hand.values).to eq([14,13,12,11,10])
		end

		it "returns the values in descending order" do
			[aceS,kingS,queenS,jackS,tenS].shuffle.each { |card| hand.add_card(card) }
			expect(hand.values).to eq([14,13,12,11,10])
		end
	end

	describe "#suits" do
		it "returns the hand mapped to each card's suit" do
			[aceS,aceH,aceD,aceC,nineS].each { |card| hand.add_card(card) }
			expect(hand.suits).to eq(%i(spades hearts diamonds clubs spades))
		end
	end
end