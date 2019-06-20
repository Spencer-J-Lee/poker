require 'rspec'
require 'player'

describe Player do
	subject(:player) { Player.new }

	describe "#initialize" do
		it "creates a new, empty hand" do
			expect(player.hand.cards).to be_empty
		end
		
		it "creates a new pot of 1000" do
			expect(player.pot).to eq(1000)
		end
	end
end