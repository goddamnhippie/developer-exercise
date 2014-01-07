#!/usr/bin/env ruby

require_relative 'blackjack'

game = Game.new

stand_at = ARGV[0] ? ARGV[0].to_i.abs : nil
stand_at = Hand::BLACKJACK_VALUE if stand_at && stand_at > Hand::BLACKJACK_VALUE

puts
puts "Your cards:  #{ game.player_cards.join ', ' }"
puts "Dealer card: #{ game.dealer_card }" unless game.player_status == :blackjack
puts

while game.player_status == :playing
  print "Hit? (Y/n) "

  should_stand = if stand_at
    game.player_values.all? { |v| v >= stand_at }
  else
    STDIN.gets.start_with? 'n', 'N'
  end

  puts (should_stand ? 'n' : 'y') if stand_at

  if should_stand
    game.player_stand!
  else
    game.player_play
    puts "=> #{ game.player_cards.last }"
  end

  puts
end

game.dealer_play ENV['DEALER_STAND']

puts game.result