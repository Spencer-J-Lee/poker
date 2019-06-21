require 'rspec'
require 'game'

describe Game do
	let(:player1) { Player.new }
	let(:player2) { Player.new }
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

	describe "#over?" do
		it "determines if only one player isn't dirt broke" do
			allow(player1).to receive(:pot).and_return(1000)
			allow(player2).to receive(:pot).and_return(1000)
			expect(game.over?).to be(false)
			
			allow(player2).to receive(:pot).and_return(0)
			expect(game.over?).to be(true)
		end
	end

	describe "#round_over?" do
		it "determines if only one player hasn't folded" do
			allow(player1).to receive(:folded?).and_return(false)
			allow(player2).to receive(:folded?).and_return(false)
			expect(game.round_over?).to be(false)

			allow(player2).to receive(:folded?).and_return(true)
			expect(game.round_over?).to be(true)
		end
	end

	describe "#next_player!" do
		before(:each) { game.next_player! }

		it "rotates @players" do
			expect(game.players).to eq([player2, player1])
		end

		it "updates @current_player" do
			expect(game.current_player).to eq(player2)
		end
	end

	describe "#reset_players" do
		it "calls #discard_hand! and #unfold on each player" do
			expect(player1).to receive(:discard_hand!)
			expect(player2).to receive(:discard_hand!)
			expect(player1).to receive(:unfold)
			expect(player2).to receive(:unfold)
			game.reset_players
		end
	end

	describe "#discard_turn" do
		it "calls Player#get_discard_amount and Player#discard" do
			expect(game.current_player).to receive(:get_discard_amount).and_return(0)
			expect(game.current_player).to receive(:discard)
			game.discard_turn
		end

		it "calls Player#add_card and Deck#draw" do
			expect(game.current_player).to receive(:get_discard_amount).and_return(1)
			expect(game.current_player).to receive(:discard)
			expect(game.deck).to receive(:draw).and_return("card")
			expect(game.current_player).to receive(:add_card).with("card")
			game.discard_turn
		end
	end
end