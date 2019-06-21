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
		it "calls #over_by_fold? and #over_by_round?" do
			expect(game).to receive(:over_by_fold?)
			expect(game).to receive(:over_by_round?)
			game.round_over?
		end
	end

	describe "#over_by_fold?" do
		it "determines if only one player hasn't folded" do
			allow(player1).to receive(:folded?).and_return(false)
			allow(player2).to receive(:folded?).and_return(false)
			expect(game.round_over?).to be(false)

			allow(player2).to receive(:folded?).and_return(true)
			expect(game.round_over?).to be(true)
		end
	end

	describe "#over_by_round?" do
		it "determines if the final round of betting has been completed" do
			expect(game.over_by_round?).to be(false)
			game.instance_variable_set(:@round, 4)
			expect(game.over_by_round?).to be(true)
		end
	end

	describe "#game_winner" do
		it "returns the winning player of the game" do
			allow(player1).to receive(:pot).and_return(0)
			allow(player2).to receive(:pot).and_return(2000)
			expect(game.game_winner).to be(player2)
		end
	end

	describe "#round_winners" do
		it "calls #find_winner_by_fold if round ends by fold" do
			allow(game).to receive(:over_by_fold?).and_return(true)
			expect(game).to receive(:find_winner_by_fold)
			game.round_winners
		end
			
		it "calls #find_winners_by_hand if round doesn't end by fold" do
			allow(game).to receive(:over_by_fold?).and_return(false)
			expect(game).to receive(:find_winners_by_hand)
			game.round_winners
		end
	end

	describe "#find_winner_by_fold" do
		it "returns the player who hasn't folded" do
			allow(player1).to receive(:folded?).and_return(true)
			allow(player2).to receive(:folded?).and_return(false)
			expect(game.find_winner_by_fold).to be(player2)
		end
	end

	describe "#find_winners_by_hand" do
		let(:aceS) { Card.new(:ace, :spades) }
		let(:kingS) { Card.new(:king, :spades) }
		let(:queenS) { Card.new(:queen, :spades) }

		before(:each) do
			4.times do
				player1.add_card(aceS)
				player2.add_card(aceS)
			end
		end

		it "returns the player with the winning hand" do
			player1.add_card(kingS)
			player2.add_card(queenS)
			expect(game.find_winners_by_hand.first).to be(player1)
		end

		it "returns all players who tied winning hands" do
			player1.add_card(kingS)
			player2.add_card(kingS)
			expect(game.find_winners_by_hand.first).to be(player1)
			expect(game.find_winners_by_hand.last).to be(player2)
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

	describe "#distribute_pot" do
		before(:each) do
				game.instance_variable_set(:@pot, 500)
		end

		it "distributes the current pot to the winning player" do
			allow(game).to receive(:round_winners).and_return([player1])
			game.distribute_pot
			expect(player1.pot).to eq(1500)
		end

		it "evenly distributes the current pot if there are multiple winning players" do
			allow(game).to receive(:round_winners).and_return([player1,player2])
			game.distribute_pot
			expect(player1.pot).to eq(1250)
			expect(player2.pot).to eq(1250)
		end
	end
end