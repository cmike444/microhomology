require 'spec_helper'

describe Microhomology do
  context "on new crispr" do
    it "adds key to ensembl url" do
      crispr = Microhomology::Crispr.new('ENSDARG00000061303', [6, 12, 24, 48, 96])
      expect(crispr.get_ensembl_url).to eq "http://rest.ensembl.org/sequence/id/ENSDARG00000061303?content-type=text/plain;mask_feature=true"
    end
  end
end