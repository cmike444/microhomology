require "microhomology/version"
require "microhomology/strategies"
require 'bio'
require 'json'
require "open-uri"

module Microhomology
  
  class Crispr
    attr_accessor :key, :strategies, :dna, :results
    
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

  class Talen
    attr_accessor :key, :dna, :results

    def initialize(key)
      @key = key
      @dna = open(get_ensembl_url).read
      @results = perform_microhomology
    end

    def get_ensembl_url
      "http://rest.ensembl.org/sequence/id/#{self.key}?content-type=text/plain;mask_feature=true"
    end

    def exons
      self.dna.scan /[A-Z]+/
    end

    def introns
      self.dna.scan /[a-z]+/
    end

    def perform_microhomology
      targets = []
      self.dna.scan(Microhomology::TALEN) do |talen|
        targets << {
                    "target" => talen,
                    "first" => Regexp.last_match.offset(0).first, 
                    "last" => Regexp.last_match.offset(0).last,
                    "microhomology" => []
                    }
      end

      if targets
        targets.each do |target|

          talen_site = Bio::Sequence::NA.new(target['target'])
          talen_site_complement = talen_site.complement.reverse

          talen1  = talen_site[0..15]
          spacer1 = talen_site[16..22]
          spacer2 = talen_site[23..30]
          talen2  = talen_site[31..47]

          talen_forward = Bio::Sequence::NA.new("#{talen1}#{spacer2}#{spacer1}#{talen2}")
          talen_reverse = talen_forward.complement.reverse

          target["microhomology"] << { 
              "forward_strand" => "#{talen_site.upcase}",
              "reverse_strand" => "#{talen_site_complement.upcase}",
              "oligo_forward" => "#{talen_forward.upcase}",
              "oligo_reverse" => "#{talen_reverse.upcase}"
            }
        end
        targets
      else
        "Sorry, no TALEN targets found."
      end
    end

  end
end
