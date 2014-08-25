require 'mkmf'

if not(have_library('cryptopp'))
  puts "No cryptopp support available."
else
  create_makefile("ruby_cryptopp")
end

