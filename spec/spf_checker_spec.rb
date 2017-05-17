require "spec_helper"

RSpec.describe SpfChecker do
  it "has a version number" do
    expect(SpfChecker::VERSION).not_to be nil
  end

  it "Responses with an error if no valid domain provided" do
    expect(SpfChecker.check('some string')).to eq(
      {
        correct: nil,
        spf_value: nil,
        message: "Please pass valid URI with protocol (\"http://\" or \"https://\")."
      }
    )
  end

  it "returns correct: true if SPF record is valid" do
    expect(SpfChecker).to receive(:check).with("http://google.com/").and_return(
      {
        correct: true,
        spf_value: [SpfChecker::VALID_VALUE],
        message: "Request successfully complete."
      }
    )

    SpfChecker.check("http://google.com/")
  end

  it "returns correct: false if SPF record is invalid" do
    expect(SpfChecker).to receive(:check).with("http://non-existent.com/").and_return(
      {
        correct: false,
        spf_value: [],
        message: "Please pass valid URI with protocol (\"http://\" or \"https://\")."
      }
    )

    SpfChecker.check("http://non-existent.com/")
  end
end
