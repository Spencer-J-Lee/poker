require 'rspec'
require 'player'

describe Player do
	subject(:player) { Player.new }
	let(:card) { double("card", rank: 10, suit: :hearts, value: 10) }

	describe "#initialize" do
		it "creates a new, empty hand" do
			expect(player.hand.cards).to be_empty
		end
		
		it "creates a new pot of 1000" do
			expect(player.pot).to eq(1000)
		end
	end

	describe "#add_card" do
		it "adds a card to the player's hand" do
			player.add_card(card)
			expect(player.hand.cards).to include(card)
		end
	end

	describe "#get_action" do
		it "gets a valid action from the user" do
			allow($stdin).to receive(:gets).and_return("fold\n")
			action = player.get_action
			expect(%w(fold see raise)).to include(action)
		end
	end

	describe "#discard" do
	end
end