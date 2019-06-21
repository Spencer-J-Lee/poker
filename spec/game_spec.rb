require 'rspec'
require 'game'

describe Game do
	let(:player1) { double("player") }
	let(:player2) { double("player") }
	subject(:game) { Game.new(player1, player2)}

	describe "#initialize" do
		it "takes any number of Player classes as an argument" do
			game
		end
	end
end