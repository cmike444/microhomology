# Microhomology
By [Chris Mikelson](http://chrismikelson.com)

[![Build Status](https://travis-ci.org/cmike444/microhomology.svg?branch=master)](https://travis-ci.org/cmike444/microhomology)

Quickly perform microhomology to speed up genetic engineering. 

With only a few lines of code, researchers can...

*   Identify microhomology canidate sites in a gene
*   Perform microhomology on sites using multiple strategies
*   Get forward and reverse sequences for each strategy's results
*   Get forward and reverse oligo sequences for each strategy's results

This gem uses [BioRuby](https://rubygems.org/gems/bio) to easily obtain compliment pairs and traverse forward or reverse strands.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'microhomology'
```

Or install it yourself via Command Line Interface:

```ruby
$ gem install microhomology
```

## Usage

>**Note:** This currently relies on the Ensembl REST API for it's data. DNA can only be obtained by using a valid Ensembl Gene ID. Additional options for obtaining DNA via other sources such as text files, formated files or 3rd Party API's is intended to be added at a later date.

#### CRIPSR

Perform microhomology on a DNA sequence using the [CRISPR](https://www.youtube.com/watch?v=2pp17E4E-O8) technique. This class takes two inputs, an Ensembl Gene ID _(string)_ and the microhomology strategies _(array)_. Using the DNA returned from Ensembl and the [CRISPR algorithm](lib/microhomology/strategies.rb), the DNA is scanned to identify target sites on both forward and reverse strands. Once target sites are identified, microhomology is performed according to each strategy in the array. 

```ruby
mh = Microhomology::Crispr.new('ENSDARG00000061303', [6, 12, 24, 48, 96])
mh.results
```

```javascript
    {
    "target": "GGCCGATTCATTAATGCAGCTGG",
    "first": 155,
    "last": 178,
    "microhomology": [
      {
        "strategy": "mh6",
        "forward_strand": "TAATGC",
        "reverse_strand": "ATTACG",
        "mh6_oligo_forward": "TAATGCAGCTGG",
        "mh6_oligo_reverse": "ATTACGTCGACC"
      },
      {
        "strategy": "mh9",
        "forward_strand": "CATTAATGC",
        "reverse_strand": "GTAATTACG",
        "mh9_oligo_forward": "CATTAATGCAGCTGG",
        "mh9_oligo_reverse": "GTAATTACGTCGACC"
      },
      {
        "strategy": "mh12",
        "forward_strand": "ATTCATTAATGC",
        "reverse_strand": "TAAGTAATTACG",
        "mh12_oligo_forward": "ATTCATTAATGCAGCTGG",
        "mh12_oligo_reverse": "TAAGTAATTACGTCGACC"
      },
      {
        "strategy": "mh24",
        "forward_strand": "GCGCGTTGGCCGATTCATTAATGC",
        "reverse_strand": "CGCGCAACCGGCTAAGTAATTACG",
        "mh24_oligo_forward": "GCGCGTTGGCCGATTCATTAATGCAGCTGG",
        "mh24_oligo_reverse": "CGCGCAACCGGCTAAGTAATTACGTCGACC"
      },
      {
        "strategy": "mh48",
        "forward_strand": "CCAATACGCAAACCGCCTCTCCCCGCGCGTTGGCCGATTCATTAATGC",
        "reverse_strand": "GGTTATGCGTTTGGCGGAGAGGGGCGCGCAACCGGCTAAGTAATTACG",
        "mh48_oligo_forward": "CCAATACGCAAACCGCCTCTCCCCGCGCGTTGGCCGATTCATTAATGCAGCTGG",
        "mh48_oligo_reverse": "GGTTATGCGTTTGGCGGAGAGGGGCGCGCAACCGGCTAAGTAATTACGTCGACC"
      }
    ]
  }
```

See an [CRISPR example](examples/crispr_example.rb) that prints out results to the console.

#### TALEN

Perform microhomology on a DNA sequence using the [TALEN](https://en.wikipedia.org/wiki/Transcription_activator-like_effector_nuclease) technique. This class takes one input, an Ensembl Gene ID _(string)_. Using the DNA returned from Ensembl and the [TALEN algorithm](lib/microhomology/strategies.rb), the DNA is scanned to identify target sites on both forward and reverse strands. Once target sites are identified, microhomology is performed. 

```ruby
mh = Microhomology::Talen.new('ENSDARG00000061303', [6, 12, 24, 48, 96])
mh.results
```

```javascript
    {
    "target": "TTGCTGTGGTTTCACTCCTTCATCTTCTTGAAGGAGCTCAACCTCCA",
    "first": 1,
    "last": 48,
    "microhomology": [
        {
          "forward_strand": "TTGCTGTGGTTTCACTCCTTCATCTTCTTGAAGGAGCTCAACCTCCA",
          "reverse_strand": "AACGACACCAAAGTGAGGAAGTAGAAGAACTTCCTCGAGTTGGAGGT",
          "oligo_forward": "TTGCTGTGGTTTCACTCTTCTTGACCTTCATAGGAGCTCAACCTCCA",
          "oligo_reverse": "AACGACACCAAAGTGAGAAGAACTGGAAGTATCCTCGAGTTGGAGGT"
        },
      ]
    }
```

See an [TALEN example](examples/talen_example.rb) that prints out results to the console.

## The DNA
The DNA from Ensembl is masked to differentiate between Introns and Exons. 

>**Note:** The default is to scan only exons when using a microhomology strategy. Adding options to choose between exons, introns or include both is intended to be added at a later date.

```ruby
mh = Microhomology::Crispr.new('ENSDARG00000061303', [3, 6, 9])
```

```ruby
mh.dna
# TTTGCTGTGGTTTCACTCCTTCagaaggtcttatttgttttcttccag
```

```ruby
mh.introns
# agaaggtcttatttgttttcttccag
```

```ruby
mh.exons
# TTTGCTGTGGTTTCACTCCTTC
```

## Roadmap
Changes to this gem will be ongoing. If you would like to contribute, please follow the process below.

* Better integration with Rails
* Additional DNA data source options
* Intron and Exon options

## Contributing

1. Fork it ( http://github.com/<my-github-username>/microhomology/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
