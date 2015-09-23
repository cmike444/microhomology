require "microhomology/version"
require "microhomology/strategies"

module Microhomology
  
  class Crispr
    attr_accessor :key, :strategies
    def initialize(key, strategies)
      @key = key 
      @strategies = []
    end

    def get_ensembl_url
      "http://rest.ensembl.org/sequence/id/#{self.key}?content-type=text/plain;mask_feature=true"
    end

    def perform_microhomology(strategies)
      strategies.each do |strategy|
        puts strategy
      end
    end
  end
end
