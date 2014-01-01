class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end

  def to_s
    [suite, name, value].to_s
  end

  def multivalue?
    value.is_a? Array
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def cards_with_single_value
    cards.reject &:multivalue?
  end

  def cards_with_multiple_values
    cards - cards_with_single_value
  end

  def values
    base = cards_with_single_value.map(&:value).reduce &:+

    return [base] if cards_with_multiple_values.empty?

    cards_with_multiple_values.map do |c|
      c.value.map { |v| base + v }
    end.flatten
  end

  def get_card card
    cards << card
  end

  def status
    return :bust      if bust?
    return :blackjack if blackjack?
    :playing
  end

  def bust?
    values.all? { |v| v > 21 }
  end

  def blackjack?
    values.any? { |v| v == 21 }
  end
end

class Game
  attr_accessor :deck, :player_hand, :dealer_hand

  def initialize
    @deck        = Deck.new
    @player_hand = Hand.new
    @dealer_hand = Hand.new
  end
end