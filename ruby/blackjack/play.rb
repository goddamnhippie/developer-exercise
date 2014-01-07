#!/usr/bin/env ruby

require_relative 'blackjack'

game = Game.new

puts "Your cards:  #{ game.player_cards.join ', ' }"
puts "Dealer card: #{ game.dealer_card.to_s }" unless game.player_status == :blackjack
puts

while game.player_status == :playing
  print "Hit? (Y/n) "

  if STDIN.gets.start_with? 'n', 'N'
    game.player_stand!
  else
    game.player_play
    puts "=> #{ game.player_cards.last }"
  end

  puts
end

game.dealer_play ENV['DEALER_STAND']

puts game.result