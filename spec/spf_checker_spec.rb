require 'spec_helper'

RSpec.describe SpfChecker do
  let(:spf_value) { 'v=spf1 include:_spf.google.com ~all ' }
  let(:checker) { SpfChecker::Domain.new(spf_value) }

  it 'has a version number' do
    expect(SpfChecker::VERSION).not_to be nil
  end

  it 'returns correct: true if SPF record is valid', :vcr do
    result = checker.check('google.com')

    expect(result.correct).to be_truthy
    expect(result.spf_value).to eq [spf_value]
  end

  it 'returns correct: false if SPF record is invalid', :vcr do
    result = checker.check('example.com')

    expect(result.correct).to be_falsey
    expect(result.spf_value).to_not eq [spf_value]
  end
end
