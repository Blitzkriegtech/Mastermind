# frozen_string_literal: true

# Handles all the logic for mode that allows human to set code.
module GameModes
  module HumanCodeCreator
    NUMBERS = {
      novice: %w[1 2 3 4].freeze,
      warrior: %w[1 2 3 4 5 6].freeze,
      no_hope: %w[1 2 3 4 5 6 7 8].freeze
    }.freeze

    def human_set_code
      puts "\nPlease create a secret code for #{@difficulty} level"
      puts "Available numbers: #{NUMBERS[@difficulty]}"
      puts "Code must contain #{code_length} numbers separated by spaces"

      loop do
        print "Please enter your secret code: "
        code = gets.chomp.downcase.split(' ')
        
        if valid_code?(code)
          @secret_code = code
          break
        else
          puts "Invalid code! Please use #{code_length} colors from #{NUMBERS[@difficulty]}"
        end
      end
    end

    private

    def code_length
      { novice: 4, warrior: 6, no_hope: 8 }[@difficulty]
    end

    def valid_code?(code)
      code.length == code_length && 
      code.all? { |digit| NUMBERS[@difficulty].include?(color) }
    end
  end
end

