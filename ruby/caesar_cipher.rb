
def self.encode_letter(letter_to_encode, shift_amount, letterToNumber, numberToLetter, alphabet_length)
    is_upper = letter_to_encode.upcase == letter_to_encode
    if letterToNumber.key?(letter_to_encode.downcase)
        new_number = (letterToNumber[letter_to_encode.downcase] + shift_amount) % alphabet_length
        new_letter = numberToLetter[new_number]
        if is_upper
            return new_letter.upcase
        else
            return new_letter
        end
    else
        return letter_to_encode
    end
end

##
# This runs a Caesar Cipher
# @param [String] string_to_encode
# @Param [Number] shift_amount
# @return [String] the encoded string
def self.caesar_cipher(string_to_encode, shift_amount, alphabet = "abcdefghijklmnopqrstuvwxyz")
    encoded_string = ""

    # Create the alphabet
    letterToNumber = Hash.new()
    numberToLetter = Hash.new()
    alphabet.split("").each_with_index {|val, index| letterToNumber[val] = index; numberToLetter[index] = val}

    string_to_encode.split("").each {|val| encoded_string.concat(encode_letter(val, shift_amount, letterToNumber, numberToLetter, alphabet.length))}

    return encoded_string
end
puts(caesar_cipher("What a string!", 5))