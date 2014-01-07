class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
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
  BLACKJACK_VALUE = 21

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
    values.reject { |v| v > BLACKJACK_VALUE }.sort.last
  end

  def status
    case
    when values.all? { |v| v > BLACKJACK_VALUE }
      :bust
    when values.any? { |v| v == BLACKJACK_VALUE }
      :blackjack
    when values.all? { |v| v >= stand_at }
      :stand
    else
      :playing
    end
  end

  def play deck, stand_value
    @stand_at = stand_value
    cards << deck.deal_card while status == :playing
  end

  def stand_at
    @stand_at || BLACKJACK_VALUE
  end

private

  def cards_with_single_value
    cards.reject { |c| c.value.is_a? Array }
  end

  def cards_with_multiple_values
    cards - cards_with_single_value
  end
end

class Game
  DEALER_STAND_VALUE = 17

  def initialize
    @deck   = Deck.new
    @player = Hand.new
    @dealer = Hand.new

    @player.cards << @deck.deal_card
    @dealer.cards << @deck.deal_card
    @player.cards << @deck.deal_card
    @dealer.cards << @deck.deal_card
  end
  end

  def play stand_value=nil
    @player.play @deck, stand_value

    case @player.status
    when :bust
      "Player busted #{ @player.values }"
    when :blackjack
      "Player blackjack #{ @player.values }"
    when :stand
      @dealer.play @deck, DEALER_STAND_VALUE

      case @dealer.status
      when :bust
        "Dealer busted #{ @dealer.values } / Player won (#{ @player.top_value })"
      when :blackjack
        "Dealer blackjack #{ @dealer.values } / Player lost (#{ @player.top_value })"
      when :stand
        if @dealer.top_value >= @player.top_value
          "Dealer won (#{ @dealer.top_value } vs #{ @player.top_value })"
        else
          "Player won (#{ @player.top_value } vs #{ @dealer.top_value })"
        end
      end
    end
  end
end