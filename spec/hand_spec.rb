require 'rspec'
require 'hand'
require 'byebug'

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
	let(:nineS ) { double("card", rank: :nine,  suit: :spades,   value: 9) }
	let(:nineH ) { double("card", rank: :nine,  suit: :hearts,   value: 9) }

	let(:royal_flush_hand) do
		[aceS,kingS,queenS,jackS,tenS].each { |card| hand.add_card(card) }
		hand
	end

	let(:straight_flush_hand) do
		[kingS,queenS,jackS,tenS,nineS].each { |card| hand.add_card(card) }
		hand
	end

	let(:four_of_a_kind_hand) do
		[aceS,aceH,aceD,aceC,nineH].each { |card| hand.add_card(card) }
		hand
	end

	let(:full_house_hand) do
		[aceS,aceH,aceD,nineS,nineH].each { |card| hand.add_card(card) }
		hand
	end

	let(:flush_hand) do
		[aceS,kingS,queenS,jackS,nineS].each { |card| hand.add_card(card) }
		hand
	end

	let(:straight_hand) do
		[kingS,queenS,jackS,tenS,nineH].each { |card| hand.add_card(card) }
		hand
	end

	let(:three_of_a_kind_hand) do
		[aceS,aceH,aceD,tenS,nineS].each { |card| hand.add_card(card) }
		hand
	end

	let(:two_pair_hand) do
		[aceS,aceH,kingS,kingH,nineS].each { |card| hand.add_card(card) }
		hand
	end

	let(:one_pair_hand) do
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
	end

	describe "#suits" do
		it "returns the hand mapped to each card's suit" do
			[aceS,aceH,aceD,aceC,nineS].each { |card| hand.add_card(card) }
			expect(hand.suits).to eq(%i(spades hearts diamonds clubs spades))
		end
	end

	describe "#sorted_values" do
		it "returns cards with more repeats first" do
			[nineS,nineS,nineS,queenS,kingS].shuffle.each { |card| hand.add_card(card) }
			expect(hand.sorted_values).to eq([9,9,9,13,12])
		end

		it "returns cards with more repeats first even if they are lower in rank" do
			[nineS,nineS,nineS,aceS,aceS].shuffle.each { |card| hand.add_card(card) }
			expect(hand.sorted_values).to eq([9,9,9,14,14])
		end

		it "returns the higher pair first when two pairs are present" do
			[nineS,nineS,aceS,aceS,kingS].shuffle.each { |card| hand.add_card(card) }
			expect(hand.sorted_values).to eq([14,14,9,9,13])
		end

		it "returns singles in descending order after repeats" do
			[kingS,jackS,tenS,nineS,nineH].shuffle.each { |card| hand.add_card(card) }
			expect(hand.sorted_values).to eq([9,9,13,11,10])
		end

		it "returns singles in descending order in the absence of repeats" do
			[kingS,jackS,tenS,nineS,queenS].shuffle.each { |card| hand.add_card(card) }
			expect(hand.sorted_values).to eq([13,12,11,10,9])
		end
	end

	describe "#repeats_tracker" do
		it "knows when a value has two copies" do
			[nineS,nineS].each { |card| hand.add_card(card) }
			expect(hand.repeats_tracker).to include(2)
		end
		
		it "knows when a value has three copies" do
			[nineS,nineS,nineS].each { |card| hand.add_card(card) }
			expect(hand.repeats_tracker).to include(3)
		end

		it "knows when a value has four copies" do
			[nineS,nineS,nineS,nineS].each { |card| hand.add_card(card) }
			expect(hand.repeats_tracker).to include(4)
		end

		it "knows when there are two pairs" do
			[nineS,nineS,aceS,aceS].shuffle.each { |card| hand.add_card(card) }
			expect(hand.repeats_tracker.count(2)).to eq(2)
		end
	end

	describe "#royal_flush?" do
	end

	describe "#straight_flush?" do
	end

	describe "#four_of_a_kind?" do
		it "determines whether a four of a kind is present" do
		end
	end

	describe "#full_house?" do
	end

	describe "#flush?" do
	end

	describe "#straight?" do
	end

	describe "#three_of_a_kind?" do
	end

	describe "#two_pair?" do
	end

	describe "#one_pair?" do
	end
end