require 'spf_checker/version'
require 'rubygems'
require 'spf/query'

module SpfChecker
  # Check domain SPF record.
  class Domain
    CORRECT = 'correct'.freeze

    Response = Struct.new(:correct, :spf_value)

    def initialize(value)
      @value = value
    end

    def check(domain)
      sample = SPF::Query::Record.parse(@value)
      result = SPF::Query::Record.query(domain)

      results = construct_results_hash(sample, result)
      valid = check_equality(results)

      Response.new(valid, result).freeze
    end

    private

    def construct_results_hash(sample, result)
      parsed_results = {}

      sample.to_a.each do |s|
        result.to_a.each do |r|
          next if s.name != r.name

          value = CORRECT if s.value == r.value
          qualifier = CORRECT if s.qualifier == r.qualifier

          parsed_results[s.name] = { value: value, qualifier: qualifier }
        end
      end

      parsed_results
    end

    def check_equality(results)
      results.values.map { |v| v.values.concat }.flatten.uniq == [CORRECT]
    end
  end
end
