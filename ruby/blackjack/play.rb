#!/usr/bin/env ruby

require_relative 'blackjack'

game  = Game.new
stand = ARGV[0].to_i.abs

if stand.zero?
  puts "Dealer card: #{ game.dealer_card.to_s }"
  puts "Enter your stand number:"

  stand = gets.chomp.to_i.abs
end

stand = Hand::BLACKJACK_VALUE if stand > Hand::BLACKJACK_VALUE

game.player_play stand
game.dealer_play

puts "Game result:  #{ game.result }"
puts "Player cards: #{ game.player_cards.join ', ' }"