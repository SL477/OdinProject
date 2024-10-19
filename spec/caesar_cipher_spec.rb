# frozen_string_literal: true

require './ruby/caesar_cipher'

describe '#caesar_cipher' do
  it 'What a string!' do
    result = caesar_cipher('What a string!', 5).strip
    expect(result).to eq('Bmfy f xywnsl!')
  end
end
