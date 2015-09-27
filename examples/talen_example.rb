require 'rubygems'
require 'microhomology'

mh = Microhomology::Talen.new('ENSDARG00000061303')
puts ' '
puts mh.key # The Ensembl Gene ID
puts mh.dna # The DNA data
puts mh.introns # The DNA data (only introns)
puts mh.exons # The DNA data (only exons)
puts mh.microhomology
# mh.results.each do |target|
#   puts ' '
#   puts "Target: " + target['target'] # Identified target site
#   puts "First: " + target['first'].to_s # Position (from left) of first base pair
#   puts "Last: " + target['last'].to_s # Position (from left) of last base pair

#   target['microhomology'].each do |result| 
#     puts " "
#     puts "   Strategy: " + result["strategy"].to_s # Microhomology strategy
#     puts "   Forward: " + result["forward_strand"] # Forward Strand
#     puts "   Reverse: " + result["reverse_strand"] # Reverse Strand
#     puts "   Oligo Forward: " + result["oligo_forward"] # Oligo Forward Strand
#     puts "   Oligo Reverse: " + result["oligo_reverse"] # Oligo Reverse Strand
#   end
# end
