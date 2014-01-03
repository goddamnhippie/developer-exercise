class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
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
  STAND_VALUE = 17

  attr_accessor :cards

  def initialize
    @cards = []
  end

  def values
    base = cards_with_single_value.map(&:value).reduce(&:+) || 0

    return [base] if cards_with_multiple_values.empty?

    cards_with_multiple_values.map do |c|
      c.value.map { |v| base + v }
    end.flatten
  end

  def top_value
    values.reject { |v| v > 21 }.sort.last
  end

  def status
    return :bust      if bust?
    return :blackjack if blackjack?
    return :stand     if stand?
    :playing
  end

  def play deck
    cards << deck.deal_card while playing?
  end

private

  def cards_with_single_value
    cards.reject &:multivalue?
  end

  def cards_with_multiple_values
    cards - cards_with_single_value
  end

  def bust?
    values.all? { |v| v > 21 }
  end

  def blackjack?
    values.any? { |v| v == 21 }
  end

  def stand?
    values.all? { |v| v > STAND_VALUE }
  end

  def playing?
    status == :playing
  end
end

class Game
  attr_accessor :winner, :message

  def initialize
    @deck        = Deck.new
    @player_hand = Hand.new
    @dealer_hand = Hand.new
  end

  def start
    @player_hand.play @deck

    case @player_hand.status
    when :bust
      self.winner  = :dealer
      self.message = "Player busted with #{ @player_hand.values }"
    when :blackjack
      self.winner  = :player
      self.message = "Player blackjack #{ @player_hand.values }"
    when :stand
      @dealer_hand.play @deck

      case @dealer_hand.status
      when :bust
        self.winner  = :player
        self.message = "Dealer busted with #{ @dealer_hand.values } / Player had #{ @player_hand.top_value }"
      when :blackjack
        self.winner  = :dealer
        self.message = "Dealer blackjack #{ @dealer_hand.values } / Player had #{ @player_hand.top_value }"
      when :stand
        if @dealer_hand.top_value >= @player_hand.top_value
          self.winner  = :dealer
          self.message = "Dealer won with #{ @dealer_hand.top_value } / Player had #{ @player_hand.top_value }"
        else
          self.winner  = :player
          self.message = "Player won with #{ @player_hand.top_value } / Dealer had #{ @dealer_hand.top_value }"
        end
      end
    end

    message
  end
end