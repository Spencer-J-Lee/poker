require 'rspec'
require 'game'

describe Game do
	let(:player1) { double("player") }
	let(:player2) { double("player") }
	subject(:game) { Game.new(player1, player2)}

	describe "#initialize" do
		it "takes any number of Player instances as an argument" do
			game
		end

		it "sets @players to an array of Player instances" do
			expect(game.players).to eq([player1, player2])
		end

		it "keeps track of whose turn it is" do
			expect(game.current_player).to eq(player1)
		end

		it "sets @deck to a new deck instance" do
			expect(game.deck.is_a?(Deck)).to be(true)
		end

		it "sets @pot to an empty pot" do
			expect(game.pot).to eq(0)
		end
	end

	describe '#over?' do
		it "returns true if only one player has money" do
			allow(player1).to receive(:pot).and_return(1000)
			allow(player2).to receive(:pot).and_return(0)
			expect(game.over?).to be(true)
		end

		it "returns false if more than one player has money" do
			allow(player1).to receive(:pot).and_return(1000)
			allow(player2).to receive(:pot).and_return(1)
			expect(game.over?).to be(false)
		end
	end
end