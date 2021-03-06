require 'minitest/autorun'
require_relative 'blackjack'

class CardTest < MiniTest::Test
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end

  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end

  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < MiniTest::Test
  def setup
    @deck = Deck.new
  end

  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end

  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    refute @deck.playable_cards.include?(card)
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class HandTest < MiniTest::Test
  def setup
    @hand = Hand.new

    @jack_of_hearts = Card.new :hearts, :jack,  Deck::NAME_VALUES[:jack]
    @jack_of_spades = Card.new :spades, :jack,  Deck::NAME_VALUES[:jack]
    @ace_of_hearts  = Card.new :hearts, :ace,   Deck::NAME_VALUES[:ace]
    @ace_of_spades  = Card.new :spades, :ace,   Deck::NAME_VALUES[:ace]
    @seven_of_clubs = Card.new :clubs,  :seven, Deck::NAME_VALUES[:seven]
  end

  def test_can_bust_when_playing
    @hand.cards = [@jack_of_hearts, @jack_of_spades, @seven_of_clubs]
    assert_equal :bust, @hand.status
  end

  def test_bust_with_two_aces
    @hand.cards = [@ace_of_spades, @ace_of_hearts, @jack_of_hearts, @jack_of_spades]
    assert_equal :bust, @hand.status
  end

  def test_can_blackjack_when_playing
    @hand.cards = [@ace_of_hearts, @jack_of_spades]
    assert_equal :blackjack, @hand.status
  end

  def test_stand_sets_correct_status
    @hand.cards = [@jack_of_hearts, @seven_of_clubs]
    @hand.stand!

    assert_equal :stand, @hand.status
  end
end

class GameTest < MiniTest::Test
  def setup
    @game = Game.new
  end

  def test_player_gets_hand_with_two_cards
    assert_equal @game.player_cards.size, 2
  end

  def test_dealer_gets_hand_with_two_cards
    assert_equal @game.instance_variable_get("@dealer").cards.size, 2
  end

  def test_player_can_see_one_dealer_card
    assert @game.dealer_card
  end

  def test_dealer_can_play_after_player_stands
    @game.dealer_play

    refute @game.finished?

    @game.player_stand!
    @game.dealer_play

    assert @game.finished?
  end
end