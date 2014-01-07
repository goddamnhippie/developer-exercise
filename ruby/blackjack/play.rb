#!/usr/bin/env ruby

require_relative 'blackjack'

game = Game.new

puts "Your cards:  #{ game.player_cards.join ', ' }"
puts "Dealer card: #{ game.dealer_card.to_s }"

while game.player_status == :playing
  puts "Hit again? (y/n)"

  if STDIN.gets.start_with? 'y', 'Y'
    game.player_play
    puts "You got: #{ game.player_cards.last }"
  else
    game.player_stand!
  end
end

game.dealer_play

puts "Game result:  #{ game.result }"
puts "Player cards: #{ game.player_cards.join ', ' }"