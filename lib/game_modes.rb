# frozen_string_literal: true

# Handles all the logic for mode that allows human to set code.
module GameModes
  # module for human to set code
  module HumanCodeCreator
    # NUMBERS = {
    #   novice: %w[red orange yellow blue].freeze,
    #   warrior: %w[red orange yellow blue green].freeze,
    #   no_hope: %w[red orange yellow blue green black].freeze
    # }.freeze
    NUMBERS = {
      novice: %w[1 2 3 4],
      warrior: %w[1 2 3 4 5],
      no_hope: %w[1 2 3 4 5 6]
    }.freeze

    def human_set_code
      puts "\nMake a secret code for #{@difficulty} level\nAvailable DIGITS: #{NUMBERS[@difficulty]}"
      puts "Code must contain #{code_length} DIGITS separated by spaces"

      loop do
        print 'Please enter your secret code: '
        code = gets.chomp.downcase.split(' ')
        break @secret_code = code if valid_code?(code)

        puts "Invalid code! Please use #{code_length} digits from #{NUMBERS[@difficulty]}"
      end
    end

    private

    def code_length
      { novice: 4, warrior: 6, no_hope: 8 }[@difficulty]
    end

    def valid_code?(code)
      code.length == code_length &&
        code.all? { |digit| NUMBERS[@difficulty].include?(digit) }
    end
  end
end
