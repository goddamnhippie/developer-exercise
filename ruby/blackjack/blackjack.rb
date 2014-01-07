class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end

  def to_s
    "#{ name.to_s.capitalize } of #{ suite.to_s.capitalize } (#{ value })"
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

    if cards_with_multiple_values.empty?
      [base]
    else
      cards_with_multiple_values.map do |c|
        c.value.map { |v| base + v }
      end.flatten
    end
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
    when stand?
      :stand
    else
      :playing
    end
  end

  def stand!
    @stand = true
  end

  def stand?
    @stand
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
  DEFAULT_STAND_VALUE = 17

  def initialize
    @deck   = Deck.new
    @player = Hand.new
    @dealer = Hand.new

    @player.cards << @deck.deal_card
    @dealer.cards << @deck.deal_card
    @player.cards << @deck.deal_card
    @dealer.cards << @deck.deal_card
  end

  def dealer_card
    @dealer.cards[1]
  end

  def player_cards
    @player.cards
  end

  def player_status
    @player.status
  end

  def player_values
    @player.values
  end

  def player_stand!
    @player.stand!
  end

  def player_play
    @player.cards << @deck.deal_card
  end

  def dealer_play stand_value=nil
    stand_at = stand_value ? stand_value.to_i : DEFAULT_STAND_VALUE

    while @dealer.status == :playing
      @dealer.cards << @deck.deal_card
      @dealer.stand! if @dealer.values.all? { |v| v >= stand_at }
    end if @player.status == :stand
  end

  def ongoing?
    @player.status == :playing || (@player.status == :stand && @dealer.status == :playing)
  end

  def finished?
    !ongoing?
  end

  def result
    case @player.status
    when :playing
      "Initial round done."
    when :bust
      "Bust!"
    when :blackjack
      "Blackjack!"
    when :stand
      buff = case @dealer.status
             when :playing
               "Player round done."
             when :bust
               "Dealer bust! You won!"
             when :blackjack
               "Dealer blackjack. You lost."
             when :stand
               if @dealer.top_value >= @player.top_value
                 "You lost."
               else
                 "You won!"
               end
             end

      unless @dealer.status == :playing
        buff << "\n\n---\n"
        buff << "Dealer hand: #{ @dealer.cards.join ', ' }.\n"
        buff << "Your hand:   #{ @player.cards.join ', ' }.\n"
      end

      buff
    end
  end
end