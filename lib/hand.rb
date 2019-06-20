require_relative 'card'

class Hand
	attr_reader :cards

	def initialize
		@cards = []
	end

	def add_card(card)
		raise ArgumentError.new "Hand already has 5 cards" if cards.count == 5
		@cards << card
	end

	def values
		cards.map(&:value)
	end

	def suits
		cards.map(&:suit)
	end

	def sorted_values
		values_group = values.group_by { |value| value }
		values_group = values_group.sort_by { |value, group| value }
		values_group = values_group.sort_by { |value, group| group.count}
		values_group.map(&:last).flatten.reverse
	end

	def repeats_tracker
		value_groups = values.group_by { |value| value }
		value_groups.map { |value, group| group.count }
	end

	def royal_flush?
	end

	def straight_flush?
	end

	def four_of_a_kind?
		repeats_tracker.include?(4)
	end

	def full_house?
	end

	def flush?
		suits.uniq.count == 1
	end

	def straight?
		ace_high_straight? || ace_low_straight?
	end

	def ace_high_straight?
		potential_straight = sorted_values
		(1..4).all? { |i| potential_straight[i] == potential_straight[0] - i }
	end

	def ace_low_straight?
		low_ace = 1
		potential_straight = sorted_values << low_ace
		potential_straight.shift
		potential_straight << low_ace
		(1..4).all? { |i| potential_straight[i] == potential_straight[0] - i }
	end

	def three_of_a_kind?
		repeats_tracker.include?(3)
	end

	def two_pair?
		repeats_tracker.count(2) == 2
	end

	def one_pair?
		repeats_tracker.count(2) == 1
	end
end

# [8,4,8,8,8] => [8,8,8,8,4]

# [2,5,2,2,5] => [2,2,2,5,5]

# [2,6,4,2,2] => [2,2,2,6,4]

# [5,3,5,8,8] => [8,8,5,5,3]

=begin

Situation(s) where Ace would be low
	straight of A 2 3 4 5


Tiebreakers

	royal_flush
		both? 
			tie

	straight_flush 
		both? 
			high card wins
		high card tie?
			tie

	four_of_a_kind
		both? 
			high card wins

	full_house
		both?
			high card in 3-kind wins

	flush
		both?
			high card wins
		high card tie?
			2nd high card wins
		2nd high card tie?
			3rd.. 4th.. 5th..
		else
			tie

	straight
		both?
			high card wins
		else
			tie

	Three of a kind
		both?
			high card wins

	Two pair
		both?
			best high pair wins
		high pair tie?
			best low pair wins
		low pair tie?
			kicker wins
		else
			tie

	One pair
		both?
			high pair wins
		else
			kicker.. 2nd.. 3rd..
			
	high_card
		tie?
			2nd highest
			3rd
			4th
			5th
		else 
			tie
			
=end