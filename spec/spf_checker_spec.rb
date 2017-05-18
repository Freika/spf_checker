require 'spec_helper'

RSpec.describe SpfChecker do
  let(:invalid_message) do
    'Please pass valid URI with protocol ("http://" or "https://").'
  end

  it 'has a version number' do
    expect(SpfChecker::VERSION).not_to be nil
  end

  it 'returns correct: true if SPF record is valid', :vcr do
    VCR.use_cassette('test') do
      spf_value = 'v=spf1 include:_spf.google.com ~all '
      checker = SpfChecker::Domain.new(spf_value)
      result = checker.check('google.com')

      expect(result.correct).to be_truthy
      expect(result.spf_value).to eq [spf_value]
    end
  end

  it 'returns correct: false if SPF record is invalid', :vcr do
    spf_value = 'v=spf1 include:_spf.google.com ~all '
    checker = SpfChecker::Domain.new(spf_value)
    result = checker.check('example.com')

    expect(result.correct).to be_falsey
    expect(result.spf_value).to_not eq [spf_value]
  end
end
