# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  # if the zip code is exactly five digits, assume that it is ok
  # if the zip code is more than five digits, truncate it to the first five digits
  # if the zip code is less than five digits, add zeros to the front until it becomes five digits

  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip) # rubocop:disable Metrics/MethodLength
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = File.read('secret.key').strip

  begin
    # legislators =
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
    # legislator_names = legislators.map(&:name)
    # legislator_names.join(', ')
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output') # rubocop:disable Lint/NonAtomicFileOperation

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'Event Manager Initialized!'

# contents = File.read('event_attendees.csv')
# puts contents

# lines = File.readlines('event_attendees.csv')
# lines.each_with_index do |line, index|
#   next if index.zero?

#   columns = line.split(',')
#   name = columns[2]
#   puts name
# end

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  # personal_letter = template_letter.gsub('FIRST_NAME', name)
  # personal_letter.gsub!('LEGISLATORS', legislators)

  # puts "#{name} #{zipcode} #{legislators}"
  # puts personal_letter

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end
