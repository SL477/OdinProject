# frozen_string_literal: true

def human_input(setter) # rubocop:disable Metrics/MethodLength
  valid = false
  until valid
    if setter
      puts 'Set the code'
    else
      puts 'Enter a guess:'
    end
    input = gets
    input = input.strip
    valid = /([1-6]){4}/.match(input) && input.length == 4
  end
  input
end

def random_guess
  guess = ''
  4.times do
    guess += String(rand(1..6))
  end
  guess
end

def guess_feedback(secret_code, guess) # rubocop:disable Metrics/MethodLength
  # If the number does not appear then 0, if it appears but in a different place then 1 else 2
  feedback = ''
  code_array = secret_code.split('')
  (0..3).each do |i|
    cell_feedback = if !code_array.include?(guess[i])
                      '0'
                    elsif code_array[i] == guess[i]
                      '2'
                    else
                      '1'
                    end
    feedback += cell_feedback
  end
  feedback
end

def game(human_setter) # rubocop:disable Metrics/MethodLength
  stop = false
  guess_number = 0
  secret_code = random_guess

  secret_code = human_input(human_setter) if human_setter

  until stop
    guess_number += 1
    guess = if human_setter
              random_guess
            else
              human_input(false)
            end

    if secret_code == guess
      stop = true
      puts 'You won!'
    else
      puts guess_feedback(secret_code, guess)
    end

    if guess_number == 15
      stop = true
      puts 'Out of time'
    end
  end
end

puts 'Mastermind!'
puts 'Guess 4 numbers of 1-6'
valid = false
human_setter = false
until valid
  puts '1 - Be the guesser'
  puts '2 - Set the code'
  choice = gets
  choice = choice.strip
  valid = %w[1 2].include?(choice)
  human_setter = true if choice == '2'
end

game(human_setter)
