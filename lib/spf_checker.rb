require 'spf_checker/version'
require 'rubygems'
require 'net/dns'

module SpfChecker
  VALID_VALUE = 'v=spf1 a mx include:_spf.kiiiosk.ru ~all'.freeze

  def self.correct(domain)
    result = Net::DNS::Resolver.start(domain, Net::DNS::TXT)
    values = result.each_mx.map(&:txt)

    {
      correct: values.include?(VALID_VALUE),
      spf_value: values
    }
  end
end
