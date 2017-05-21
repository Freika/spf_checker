require 'spf_checker/version'
require 'rubygems'
require 'spf/query'

module SpfChecker
  class Domain
    Response = Struct.new(:correct, :spf_value)

    def initialize(value)
      @value = value
    end

    def check(domain)
      sample = SPF::Query::Record.parse(@value)
      result = SPF::Query::Record.query(domain)

      parsed_results = {}

      sample.to_a.each do |e|
        result.to_a.each do |r|
          if e.name == r.name
            value = 'correct' if e.value == r.value
            qualifier = 'correct' if e.qualifier == r.qualifier

            parsed_results[e.name] = { value: value, qualifier: qualifier }
          end
        end
      end

      valid =
        parsed_results.values.map do |v|
          v.values.concat
        end.flatten.uniq == ['correct']

      Response.new(valid, result).freeze
    end
  end
end
