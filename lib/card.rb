class Card
	attr_reader :rank, :suit, :value

	def self.ranks
		VALUES.keys
	end

	def self.suits
		%i(clubs diamonds hearts spades)
	end

	VALUES = {
		two:    2,
		three:  3,
		four:   4,
		five:   5,
		six:    6,
		seven:  7,
		eight:  8,
		nine:   9,
		ten:   10,
		jack:  11,
		queen: 12,
		king:  13,
		ace:   14
	}

	def initialize(rank, suit)
		@rank  = rank
		@suit  = suit
		@value = VALUES[rank]
	end

	def inspect
		"#{rank}_#{suit}"
	end
end