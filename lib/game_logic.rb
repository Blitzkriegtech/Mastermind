# frozen_string_literal: true

# Main class that handles the entire logic of the game
class GameLogic
  NUMBERS = {
    novice: %w[1 2 3 4].freeze,
    warrior: %w[1 2 3 4 5 6].freeze,
    no_hope: %w[1 2 3 4 5 6 7 8].freeze
  }.freeze

  def initialize
    @difficulty = :novice
    @secret_code = []
    @guess_count = 0
  end

  def setup_game
    set_difficulty
    create_secret_code
    @guess_count = 0
    play
  end

  def set_difficulty
    print "\nSelect difficulty: (a) Novice, (b) Warrior, or (c) Abandon all hope: "
    input = gets.chomp.downcase

    case input
    when 'a', 'novice' then @difficulty = :novice
    when 'b', 'warrior' then @difficulty = :warrior
    when 'c', 'abandon all hope' then @difficulty = :no_hope
    else puts "\nInvalid selection.\nDifficulty level set to NOVICE by default."
    end
  end

  def play
    puts "\nThe SECRET CODE has #{@secret_code.length} digits made of: #{NUMBERS[@difficulty].join(', ')} nos."
    puts 'Use (q)uit at any time to end the game or use (c)heat to cheat your way out.'

    loop do
      print "\nWhat's your guess?: "

      case (input = gets.chomp.downcase)
      when 'q', 'quit' then exit_game
      when 'c', 'cheat' then puts "The SECRET CODE is: ***#{@secret_code.join.upcase}***"
      else process_guess(input)
      end
    end
  end

  def create_secret_code
    numbers = NUMBERS[@difficulty]
    lengths = { novice: 4, warrior: 6, no_hope: 8 }
    length = lengths[@difficulty]
    @secret_code = Array.new(length) { numbers.sample }
  end

  def process_guess(guess)
    if guess.length < @secret_code.length then puts "\nYour guess is too short."
    elsif guess.length > @secret_code.length then puts "\nYour guess is too long."
    else
      evaluate_guess(guess.chars)
    end
  end

  def evaluate_guess(guess)
    @guess_count += 1

    if @guess_count == 12
      puts "You have lost, SAD!\n+++++++++++"
      exit_game
    end

    if guess == @secret_code
      puts 'You have won! What CHAD!'
      exit_game
    end

    match_chars = guess.zip(@secret_code).count { |g, s| g == s } # counts correct characters in any order.
    match_indices = # counts correct characters in correct index.
      guess.each_with_index.count do |g, i|
        g == @secret_code[i]
      end
    puts "\n#{guess.join.upcase} has #{match_chars} of the correct digits with #{match_indices} in correct order."
    puts "\nYou've taken #{@guess_count} guess#{@guess_count > 1 ? 'es' : ''}."
  end

  def exit_game
    puts "\nARIGATO GOZAIMASU!\n******************"
    exit
  end
end
