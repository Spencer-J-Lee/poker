require 'rspec'
require 'hand'
require 'byebug'

describe Hand do 
	subject(:hand) { Hand.new }
	let(:aceS   ) { double("card", rank: :ace,   suit: :spades,   value: 14) }
	let(:aceH   ) { double("card", rank: :ace,   suit: :hearts,   value: 14) }
	let(:aceD   ) { double("card", rank: :ace,   suit: :diamonds, value: 14) }
	let(:aceC   ) { double("card", rank: :ace,   suit: :clubs,    value: 14) }
	let(:kingS  ) { double("card", rank: :king,  suit: :spades,   value: 13) }
	let(:queenS ) { double("card", rank: :queen, suit: :spades,   value: 12) }
	let(:jackS  ) { double("card", rank: :jack,  suit: :spades,   value: 11) }
	let(:tenS   ) { double("card", rank: :ten,   suit: :spades,   value: 10) }
	let(:nineS  ) { double("card", rank: :nine,  suit: :spades,   value:  9) }
	let(:nineH  ) { double("card", rank: :nine,  suit: :hearts,   value:  9) }
	let(:fiveH  ) { double("card", rank: :five,  suit: :hearts,   value:  5) }
	let(:fourH  ) { double("card", rank: :four,  suit: :hearts,   value:  4) }
	let(:threeH ) { double("card", rank: :three, suit: :hearts,   value:  3) }
	let(:twoH   ) { double("card", rank: :two,   suit: :hearts,   value:  2) }
	
	let(:royal_flush_hand) do
		new_hand = Hand.new
		[aceS,kingS,queenS,jackS,tenS].each { |card| new_hand.add_card(card) }
		new_hand
	end

	let(:straight_flush_hand) do
		new_hand = Hand.new
		[kingS,queenS,jackS,tenS,nineS].each { |card| new_hand.add_card(card) }
		new_hand
	end

	let(:four_of_a_kind_hand) do
		new_hand = Hand.new
		[aceS,aceH,aceD,aceC,nineH].each { |card| new_hand.add_card(card) }
		new_hand
	end

	let(:full_house_hand) do
		new_hand = Hand.new
		[aceS,aceH,aceD,nineS,nineH].each { |card| new_hand.add_card(card) }
		new_hand
	end

	let(:flush_hand) do
		new_hand = Hand.new
		[aceS,kingS,queenS,jackS,nineS].each { |card| new_hand.add_card(card) }
		new_hand
	end

	let(:straight_hand) do
		new_hand = Hand.new
		[kingS,queenS,jackS,tenS,nineH].each { |card| new_hand.add_card(card) }
		new_hand
	end

	let(:three_of_a_kind_hand) do
		new_hand = Hand.new
		[aceS,aceH,aceD,tenS,nineS].each { |card| new_hand.add_card(card) }
		new_hand
	end

	let(:two_pair_hand) do
		new_hand = Hand.new
		[aceS,aceH,kingS,kingS,nineS].each { |card| new_hand.add_card(card) }
		new_hand
	end

	let(:one_pair_hand) do
		new_hand = Hand.new
		[aceS,aceH,queenS,jackS,tenS].each { |card| new_hand.add_card(card) }
		new_hand
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
			expect(royal_flush_hand.values).to eq([14,13,12,11,10])
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
		it "determines if a four of a kind is present" do
			expect(four_of_a_kind_hand.four_of_a_kind?).to be(true)
			expect(one_pair_hand.four_of_a_kind?).to be(false)
		end
	end

	describe "#full_house?" do
	end

	describe "#flush?" do
		it "determines if a flush is present" do
			expect(flush_hand.flush?).to be(true)
			expect(one_pair_hand.flush?).to be(false)
		end
	end

	describe "#straight?" do
		it "determines if a straight is present" do
			expect(straight_hand.straight?).to be(true)
			expect(one_pair_hand.straight?).to be(false)
		end

		it "handles ace-high straights" do
			[aceS,kingS,queenS,jackS,tenS].each { |card| hand.add_card(card) }
			expect(hand.straight?).to be(true)
		end

		it "handles ace-low straights" do
			[aceS,twoH,threeH,fourH,fiveH].each { |card| hand.add_card(card) }
			expect(hand.straight?).to be(true)
		end
	end

	describe "#three_of_a_kind?" do
		it "determines if a three of a kind is present" do
			expect(three_of_a_kind_hand.three_of_a_kind?).to be(true)
			expect(one_pair_hand.three_of_a_kind?).to be(false)
		end
	end

	describe "#two_pair?" do
		it "determines if two pairs are present" do
			expect(two_pair_hand.two_pair?).to be(true)
			expect(one_pair_hand.two_pair?).to be(false)
		end
	end

	describe "#one_pair?" do
		it "determines if one pair is present" do
			expect(one_pair_hand.one_pair?).to be(true)
			expect(two_pair_hand.one_pair?).to be(false)
		end
	end
end