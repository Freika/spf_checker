require 'spf_checker/version'
require 'rubygems'
require 'addressable/uri'
require 'net/dns'

module SpfChecker
  VALID_VALUE = ENV['VALID_SPF_VALUE'].freeze

  def self.check(uri)
    if uri.include?('http://') || uri.include?('https://')
      domain = Addressable::URI.parse(uri).host
      message = 'Request successfully complete.'

      result = Net::DNS::Resolver.start(domain, Net::DNS::TXT)
      values = result.each_mx.map(&:txt)
    else
      message = 'Please pass valid URI with protocol ("http://" or "https://").'
    end

    response(message, values)
  end

  def self.response(message, values = [])
    {
      correct: values&.include?(VALID_VALUE),
      spf_value: values,
      message: message
    }
  end
  private_class_method :response
end
