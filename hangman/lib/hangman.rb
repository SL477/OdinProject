
def get_random_word
  ret = ''
  line = 0
  File.open('google-10000-english-no-swears.txt', 'r') {|f| line = Random.rand(f.count)}
  File.open('google-10000-english-no-swears.txt', 'r'){|f| line.times{ ret = f.gets }}
  ret = ret.strip
  ret
end

def get_guess(incorrect_letters, correct_letters)
  valid = false
  until valid
    puts 'Guess a letter'
    input = gets
    input = input.strip
    input = input.downcase
    valid = /([a-z]){1}/.match(input) && input.length == 1 && !correct_letters.include?(input) && !incorrect_letters.include?(input)
  end
  input
end

def update_display_word(word_to_guess, display_word, guess)
  ret = display_word
  for i in 0...(word_to_guess.length)
    if word_to_guess[i] == guess
      display_word[i] = guess
    end
  end
  ret
end

def game
  number_guesses = 15

  word_to_guess = get_random_word()
  display_word = ''
  display_word = display_word.rjust(word_to_guess.length, '_')
  incorrect_letters = ['a']
  correct_letters = []
  stop = false

  puts 'Hangman'
  puts word_to_guess

  until stop
    
    puts "#{display_word}\nNumber of guesses remaining #{number_guesses}. Incorrect letters: #{incorrect_letters.join(', ')}."
    guess = get_guess(incorrect_letters, correct_letters)
    if word_to_guess.include?(guess)
      correct_letters.push(guess)
      display_word = update_display_word(word_to_guess, display_word, guess)
      stop = !display_word.include?('_')
    else
      incorrect_letters.push(guess)
    end

    number_guesses -= 1
    if number_guesses <= 0
      stop = true
    end
  end
end

game
