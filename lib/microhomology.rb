require "microhomology/version"
require "microhomology/strategies"
require 'bio'
require 'json'
require "open-uri"

module Microhomology
  
  class Crispr
    attr_accessor :key, :strategies, :dna, :targets, :results
    
    def initialize(key, strategies)
      @key = key 
      @strategies = strategies
      @dna = open(get_ensembl_url).read
      @results = perform_microhomology
    end

    def get_ensembl_url
      "http://rest.ensembl.org/sequence/id/#{self.key}?content-type=text/plain;mask_feature=true"
    end

    def get_bio_sequence
      Bio::Sequence::NA.new(self.dna)
    end

    def exons
      self.dna.scan /[A-Z]+/
    end

    def introns
      self.dna.scan /[a-z]+/
    end

    def perform_microhomology
      targets = []
      self.dna.scan(Microhomology::CRISPR) do |crispr|
        # Compile first set of data to JSON
        targets << {
                    "target" => crispr,
                    "first" => Regexp.last_match.offset(0).first, 
                    "last" => Regexp.last_match.offset(0).last,
                    "microhomology" => []
                    }
      end

      if targets
        targets.each do |target|

          self.strategies.each do |strategy|
            # Double strand break based on polarity
            if target["target"][0] == "G"
              mh_last_char = target["last"] - 7
            else
              mh_last_char = target["first"] + 5
            end
              mh_first_char = mh_last_char - (strategy - 1)

            target["microhomology"] << { 
              "strategy" => "#{strategy}",
              "forward_strand" => get_bio_sequence[mh_first_char..mh_last_char].upcase,
              "reverse_strand" => get_bio_sequence[mh_first_char..mh_last_char].complement.reverse.upcase,
              "oligo_forward" => get_bio_sequence[mh_first_char...target["last"]].upcase,
              "oligo_reverse" => get_bio_sequence[mh_first_char...target["last"]].complement.reverse.upcase
            }
          end
        end
        targets
      else
        "Sorry, no CRISPR targets found."
      end
    end
  end
end
