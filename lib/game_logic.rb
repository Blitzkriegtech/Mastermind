# frozen_string_literal: true

require_relative 'game_modes'
require_relative 'computer_logic'
# Main class that handles the entire logic of the game
class GameLogic
  include GameModes::HumanCodeCreator

  NUMBERS = {
    novice: %w[1 2 3 4],
    warrior: %w[1 2 3 4 5],
    no_hope: %w[1 2 3 4 5 6]
  }.freeze

  def initialize
    @difficulty = :novice
    @secret_code = []
    @guess_count = 0
    @game_mode = :human_guesser
    @game_over = false # flag to ensure the loop ends when it becomes true
  end

  def play
    set_difficulty
    set_game_mode
    set_secret_code
    commence_game
  end

  private

  def set_game_mode
    print "\nPlease choose a game mode: (1) CODEBREAKER (2) CODEMAKER: "
    @game_mode = gets.chomp == '2' ? :computer_guesser : :human_guesser
  end

  def set_secret_code
    if @game_mode == :computer_guesser
      human_set_code
    else
      generate_computer_code
    end
  end

  def generate_computer_code
    digits = NUMBERS[@difficulty]
    length = code_length
    @secret_code = Array.new(length) { digits.sample }
  end

  def commence_game
    if @game_mode == :computer_guesser
      start_computer_guessing
    else
      start_human_guessing
    end
  end

  def start_human_guessing
    puts "\nI have generated a #{@difficulty} sequence w/ #{@secret_code.length} made of: #{NUMBERS[@difficulty]}"
    puts 'Use (q) at anytime to end the game or (c)heat to view code.'

    loop do
      print "\nWhat's your guess?: "
      guess = gets.chomp.downcase
      process_human_guess(guess)
      break if @game_over
    end
  end

  def process_human_guess(guess)
    case guess
    when 'c', 'cheat' then puts "****SECRET CODE: #{@secret_code}****"
    when 'q', 'quit' then exit_game
    else evaluate_human_guess(guess)
    end
  end

  def evaluate_human_guess(guess)
    converted_guess = guess.split(' ')
    return unless valid_guess?(converted_guess)

    exact_matches = calculate_exact_matches(converted_guess)
    correct_digits = calculate_correct_digits(converted_guess) - exact_matches
    @guess_count += 1

    puts feedback_message(converted_guess, exact_matches, correct_digits)
    check_game_over(exact_matches)
  end

  def start_computer_guessing
    @solver = BotSolver.new(NUMBERS[@difficulty], @secret_code.length)
    puts "\nBOT will try to guess your #{@difficulty.upcase} code in 12 tries or less!"

    12.times do |attempt|
      computer_turn(attempt + 1)
      break if @game_over
    end

    puts "\nBOT failed to guess your code! You won! What a CHAD!" unless @game_over
    exit_game
  end

  def computer_turn(attempt)
    guess = @solver.next_guess
    puts "\nAttempt #{attempt}: Computer guesses #{guess}"

    exact_matches = calculate_exact_matches(guess)
    correct_digits = calculate_correct_digits(guess) - exact_matches

    if exact_matches == @secret_code.length
      puts "\nBOT guessed your CODE: #{@secret_code} in #{attempt} attempts!"
      @game_over = true
    else
      puts "Feedback: #{exact_matches} exact, #{correct_digits} digit matches."
      @solver.receive_feedback(guess, exact_matches, correct_digits)
    end
  end

  def check_game_over(exact_matches)
    win if exact_matches == @secret_code.length
    lose if @guess_count >= 12
  end

  def calculate_exact_matches(guess)
    guess.each_with_index.count { |digit, i| digit == @secret_code[i] }
  end

  def calculate_correct_digits(guess)
    code_count = @secret_code.tally
    guess_count = guess.tally
    code_count.sum { |digit, count| [count, guess_count[digit] || 0].min }
  end

  def valid_guess?(guess)
    return true if guess.length == @secret_code.length && guess.all? { |c| NUMBERS[@difficulty].include?(c) }

    puts "\nInvalid guess! or Guess is too short/long."
    puts "Please enter #{@secret_code.length} from #{NUMBERS[@difficulty]}"
    false
  end

  def feedback_message(guess, exact, correct)
    <<~MSG
      '\n#{guess}' has #{exact + correct} correct digits (#{exact} exact, #{correct} positionless)
      Guesses used: #{@guess_count}/12
    MSG
  end

  def set_difficulty
    print "\nChoose a level of difficulty (n) for 'NOVICE', (w) for 'WARRIOR', and (?) for 'NO HOPE'.: "
    response = gets.chomp.downcase

    @difficulty = case response
                  when 'n', 'novice' then :novice
                  when 'w', 'warrior' then :warrior
                  when '?', 'no hope' then :no_hope
                  else puts 'Invalid! Defaulting to novice.'
                       :novice
                  end
  end

  def exit_game
    @game_over = true
    puts "\nThank you for playing the game."
    exit
  end

  def announce_winner
    if @game_mode == :human_guesser
      puts "\nGratzzzz!! YOU HAVE WON! The code was #{@secret_code}\nWHAT A CHAD!"
    else
      puts "\nBOT has guessed your CODE. YOU LOSE!\nTRY HARDER next time."
    end
  end

  def win
    @game_over = true
    announce_winner
    exit_game
  end

  def lose
    @game_over = true
    if @game_mode == :human_guesser
      puts "\nYou`ve used all 12 guesses! The secret code was #{@secret_code}.\nTRY HARDER next time.\nYOU LOSE!"
    elsif @game_mode == :computer_guesser
      puts "\nCOMPUTER have used all 12 guesses! The secret code is safe! YOU WON!!\nWHAT A CHAD!!!"
    end
    exit_game
  end
end
