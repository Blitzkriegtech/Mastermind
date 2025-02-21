# frozen_string_literal: true

require_relative 'instruction'
require_relative 'game_logic'

# Main class that starts game.
class Game
  include HowToPlay

  def initialize(game_logic = GameLogic.new)
    @game_logic = game_logic
  end

  def start
    loop do
      print "\nWelcome to -=MASTERMIND=-\nWould you like to (p)lay, read game (i)nstructions, or (q)uit?: "
      input = gets.chomp.downcase

      case input
      when 'p', 'play' then @game_logic.play
      when 'i', 'instructions' then instructions
      when 'q', 'quit' then @game_logic.exit_game
      else puts "\nInvalid input. Please choose from (p)lay, (i)nstructions, or (q)uit options.\nThank you\n---------"
      end
    end
  end
end
