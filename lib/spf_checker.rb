require 'spf_checker/version'
require 'rubygems'
require 'net/dns'
require 'byebug'

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

    def parse(spf)
      a_record = spf =~ /\ a\ /
      mx_record = spf =~ /\ mx\ /
      v_record = spf =~ /v=spf1\ /
      include_record = spf =~ /include:_spf.kiiiosk.ru/
      all_record = spf =~ /\ ~all/

      if a_record && mx_record && v_record && include_record && all_record
        valid = true
      end

      valid
    end
  end
end

# a = SpfChecker::Domain.new('lalala')

# "v=spf1 a mx include:_spf.kiiiosk.ru ~all"
