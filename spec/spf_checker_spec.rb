require 'spec_helper'

RSpec.describe SpfChecker do
  let(:invalid_message) do
    'Please pass valid URI with protocol (\'http://\" or \"https://\").'
  end

  it 'has a version number' do
    expect(SpfChecker::VERSION).not_to be nil
  end

  it 'Responses with an error if no valid domain provided' do
    expect(SpfChecker.check('some string')).to eq(
      correct: nil,
      spf_value: nil,
      message: invalid_message
    )
  end

  it 'returns correct: true if SPF record is valid' do
    expect(SpfChecker).to receive(:check).with('http://google.com/').and_return(
      correct: true,
      spf_value: [SpfChecker::VALID_VALUE],
      message: 'Request successfully complete.'
    )

    SpfChecker.check('http://google.com/')
  end

  it 'returns correct: false if SPF record is invalid' do
    expect(SpfChecker).to receive(:check).with('http://non-existent.com/').and_return(
      correct: false,
      spf_value: [],
      message: invalid_message
    )

    SpfChecker.check('http://non-existent.com/')
  end
end
