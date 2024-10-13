def encode_letter(letter_to_encode, shift_amount, letter_to_number, number_to_letter, alphabet_length) # rubocop:disable Style/FrozenStringLiteralComment
  is_upper = letter_to_encode.upcase == letter_to_encode
  return letter_to_encode unless letter_to_number.key?(letter_to_encode.downcase)

  new_number = (letter_to_number[letter_to_encode.downcase] + shift_amount) % alphabet_length
  new_letter = number_to_letter[new_number]
  return new_letter.upcase if is_upper

  new_letter
end

##
# This runs a Caesar Cipher
# @param [String] string_to_encode
# @Param [Number] shift_amount
# @return [String] the encoded string
def caesar_cipher(string_to_encode, shift_amount, alphabet = 'abcdefghijklmnopqrstuvwxyz') # rubocop:disable Metrics/MethodLength
  encoded_string = ''

  # Create the alphabet
  letter_to_number = {}
  number_to_letter = {}
  alphabet.chars.each_with_index do |val, index|
    letter_to_number[val] = index
    number_to_letter[index] = val
  end

  string_to_encode.chars.each do |val|
    encoded_string.concat(encode_letter(val, shift_amount, letter_to_number, number_to_letter, alphabet.length))
  end

  encoded_string
end
# puts(caesar_cipher('What a string!', 5))
