#!/usr/bin/env ruby

require_relative 'blackjack'

SIMULATE_STAND_VALUE = 17

play_mode = ARGV[0] == 'simulate' ? :simulate : :interactive

game = Game.new

if play_mode == :interactive
  puts "Dealer card: #{ game.dealer_card.to_s }"
  puts "Enter your stand value:"

  stand_value = gets.chomp.to_i.abs
  stand_value = Hand::BLACKJACK_VALUE if stand_value > Hand::BLACKJACK_VALUE
else
  stand_value =  SIMULATE_STAND_VALUE
end

result = game.play stand_value

puts result