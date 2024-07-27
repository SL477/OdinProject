require 'json'

class HangmanSave
  attr_accessor :word_to_guess, :display_word, :incorrect_letters, :correct_letters, :number_guesses

  def initialize(word_to_guess, display_word, incorrect_letters, correct_letters, number_guesses)
    @word_to_guess = word_to_guess
    @display_word = display_word
    @incorrect_letters = incorrect_letters
    @correct_letters = correct_letters
    @number_guesses = number_guesses
  end

  def to_json
    JSON.dump({
      :word_to_guess => word_to_guess,
      :display_word => display_word,
      :incorrect_letters => incorrect_letters,
      :correct_letters => correct_letters,
      :number_guesses => number_guesses
    })
  end

  def self.from_json(string)
    data = JSON.load string
    self.new(data['word_to_guess'], data['display_word'], data['incorrect_letters'], data['correct_letters'], data['number_guesses'])
  end
end

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
    puts 'Guess a letter or type save to save the game'
    input = gets
    input = input.strip
    input = input.downcase
    valid = input == 'save' || (/([a-z]){1}/.match(input) && input.length == 1 && !correct_letters.include?(input) && !incorrect_letters.include?(input))
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
  puts 'Hangman'
  puts '1 - play the game'
  puts '2 - load a game'
  input = gets
  input = input.strip
  if input == '2'
    game_data = HangmanSave.from_json(File.read('save.json').strip)
  else
    word_to_guess = get_random_word()
    game_data = HangmanSave.new(
      word_to_guess,
      ''.rjust(word_to_guess.length, '_'),
      [],
      [],
      15
    )
  end
  stop = false
  saving = false
  
  # puts game_data.word_to_guess

  until stop
    puts "#{game_data.display_word}\nNumber of guesses remaining #{game_data.number_guesses}. Incorrect letters: #{game_data.incorrect_letters.join(', ')}."
    guess = get_guess(game_data.incorrect_letters, game_data.correct_letters)

    if guess == 'save'
      stop = true
      saving = true
    else
      if game_data.word_to_guess.include?(guess)
        game_data.correct_letters.push(guess)
        game_data.display_word = update_display_word(game_data.word_to_guess, game_data.display_word, guess)
        stop = !game_data.display_word.include?('_')
      else
        game_data.incorrect_letters.push(guess)
      end

      game_data.number_guesses -= 1
      if game_data.number_guesses <= 0
        stop = true
      end
    end
  end

  if !saving && game_data.display_word.include?('_')
    puts "You lost. The word was #{game_data.word_to_guess}."
  elsif !saving
    puts "You won! The word was #{game_data.word_to_guess}."
  elsif saving
    File.open('save.json', 'w') do |file|
      file.puts game_data.to_json
    end
  end
end

game
