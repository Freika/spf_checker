require 'spf_checker/version'
require 'rubygems'
require 'spf/query'

module SpfChecker
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

      sample.to_a.each do |e|
        result.to_a.each do |r|
          if e.name == r.name
            value = CORRECT if e.value == r.value
            qualifier = CORRECT if e.qualifier == r.qualifier

            parsed_results[e.name] = { value: value, qualifier: qualifier }
          end
        end
      end

      parsed_results
    end

    def check_equality(results)
      results.values.map { |v| v.values.concat }.flatten.uniq == [CORRECT]
    end
  end
end
