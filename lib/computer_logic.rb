# frozen_string_literal: true

# Handles all logic for computer as a player
class BotSolver
  def initialize(digits, length)
    @digits = digits
    @length = length
    @possible_codes = generate_all_possible_codes
    @previous_guesses = []
  end

  def generate_all_possible_codes
    @digits.repeated_permutation(@length).to_a # gets all possible permutation of given digits and converts it to array
  end

  # get the first permutation as next guess
  def next_guess
    @possible_codes.first || @digits.sample(@length) # serves as fallback if possible_codes turns out empty
  end

  def receive_feedback(guess, exact_matches, correct_digits)
    @previous_guesses << guess
    @possible_codes.select! do |code|
      calculated_exact = exact_matches(code, guess)
      calculated_correct = correct_digit_count(code, guess) - calculated_exact
      calculated_exact == exact_matches && calculated_correct == correct_digits
    end
  end

  private

  # counts the elements/digits that are both correct in pos and elements/digits
  def exact_matches(code, guess)
    code.zip(guess).count { |c, g| c == g }
  end

  # counts the correct elements regardless of the position/index
  def correct_digit_count(code, guess)
    code_counts = code.tally
    guess_counts = guess.tally
    code_counts.sum { |digits, count| [count, guess_counts[digits] || 0].min }
  end
end
