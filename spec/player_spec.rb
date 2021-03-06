require 'rspec'
require 'player'

describe Player do
	subject(:player) { Player.new('Player') }
	let(:card) { double("card", rank: 10, suit: :hearts, value: 10) }

	describe "#initialize" do
		it "creates a new, empty hand" do
			expect(player.hand.cards).to be_empty
		end
		
		it "creates a new pot of 1000" do
			expect(player.pot).to eq(1000)
		end

		it "sets @folded to false" do
			expect(player.folded).to be(false)
		end
	end
	
	describe "#fold" do
		it "sets @folded to true" do
			player.fold
			expect(player.folded).to be(true)
		end
	end

	describe "#unfold" do
		it "sets @folded to false" do
			player.unfold
			expect(player.folded).to be(false)
		end
	end

	describe "#folded?" do
		it "returns @folded" do
			expect(player.folded?).to be(false)
		end
	end

	describe "#add_card" do
		it "adds a card to the player's hand" do
			player.add_card(card)
			expect(player.hand.cards).to include(card)
		end
	end

	describe "#discard" do
		it "discards as many cards as the amount given" do
			allow(player).to receive(:get_card_index).and_return(0)
			player.add_card(card)
			player.discard(1)
			expect(player.hand.cards).to be_empty
		end
	end

	describe "#discard_hand!" do
		it "removes all cards from hand" do
			player.add_card(card)
			player.discard_hand!
			expect(player.hand.cards).to be_empty
		end
	end

	describe "#add_to_pot" do
		it "adds amount given to the pot" do
			player.add_to_pot(42)
			expect(player.pot).to eq(1042)
		end
	end

	describe "#get_action" do
		it "gets a valid action from the user" do
			allow($stdin).to receive(:gets).and_return("fold\n")
			action = player.get_action
			expect(%w(fold see raise)).to include(action)
		end
	end

	describe "#get_card_index" do
		it "gets a valid card index from the user" do
			allow($stdin).to receive(:gets).and_return("0\n")
			card_index = player.get_card_index
			expect([0,1,2,3,4]).to include(card_index)
		end
	end

	describe "#get_discard_amount" do
		it "gets a valid discard amount from the user" do
			allow($stdin).to receive(:gets).and_return("3\n")
			discard_amount = player.get_discard_amount
			expect([0,1,2,3]).to include(discard_amount)
		end
	end

	describe "#get_raise_amount" do
		it "gets a valid raise amount from the user" do
			allow($stdin).to receive(:gets).and_return("500\n")
			raise_amount = player.get_raise_amount
			expect((1..1000).to_a).to include(raise_amount)
		end

		it "subtracts raise amount from the pot" do
			allow($stdin).to receive(:gets).and_return("600\n")
			player.get_raise_amount
			expect(player.pot).to eq(400)
		end
	end
end