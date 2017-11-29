# frozen_string_literal: true

require 'amazon_product_api/item_lookup_endpoint'

describe AmazonProductAPI::ItemLookupEndpoint do
  AWSTestCredentials = Struct.new(:access_key, :secret_key, :associate_tag)

  let(:aws_credentials) {
    AWSTestCredentials.new('aws_access_key',
                           'aws_secret_key',
                           'aws_associates_tag')
  }
  let(:query) {
    AmazonProductAPI::ItemLookupEndpoint.new('corgi_asin', aws_credentials)
  }

  describe '#url' do
    subject(:url) { query.url }

    it { should start_with 'http://webservices.amazon.com/onca/xml' }
    it { should include 'AWSAccessKeyId=aws_access_key' }
    it { should include 'AssociateTag=aws_associates_tag' }
    it { should include 'Operation=ItemLookup' }
    it { should include 'ItemId=corgi_asin' }
    it { should include 'ResponseGroup=ItemAttributes%2COffers%2CImages' }
    it { should include 'Service=AWSECommerceService' }
    it { should include 'Timestamp=' }
    it { should include 'Signature=' }
  end

  describe '#get' do
    let(:http_double) { double('http') }

    it 'should make a `get` request to the specified http library' do
      expect(http_double).to receive(:get).with(String)
      query.get(http: http_double)
    end
  end

  describe '#response', :external do
    subject { query.response }

    it { should be_a AmazonProductAPI::SearchItem }

    it 'should have the item information' do
      expect(subject.asin).to eq 'B00TFT77ZS'
      expect(subject.title).to eq 'Douglas Toys Louie Corgi'
      expect(subject.price_cents).to eq 1350
    end
  end
end
