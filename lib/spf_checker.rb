require 'spf_checker/version'
require 'rubygems'
require 'net/dns'

module SpfChecker
  class Domain
    Response = Struct.new(:correct, :spf_value)

    def initialize(value)
      @value = value
    end

    def check(domain)
      result = Net::DNS::Resolver.start(domain, Net::DNS::TXT)
      spf_records = result.each_mx.map(&:txt)

      valid = spf_records.any? { |record| parse(record) }

      Response.new(valid, spf_records).freeze
    end

    private

    def parse(spf)
      @value.split.all? do |arg|
        arg = " #{arg} " if arg.length <= 2
        spf =~ /#{arg}/
      end
    end
  end
end
