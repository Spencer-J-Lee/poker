require 'rspec'
require 'card'

describe Card do
	subject(:card) { Card.new(:ace, :spades) }
	
	it "holds a rank" do
		expect(card.rank).to eq(:ace)
	end

	it "holds a suit" do
		expect(card.suit).to eq(:spades)
	end

	it "holds a value" do
		expect(card.value).to eq(14)
	end

	describe "::ranks" do
		it "returns an array of all ranks" do
			expect(Card.ranks).to eq(%i(one two three four five six seven eight nine ten jack queen king ace))
		end
	end
end