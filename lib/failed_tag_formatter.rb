require 'json'
require "failed_tag_formatter/version"
require "rspec/core/formatters/base_text_formatter"

class FailedTagFormatter < RSpec::Core::Formatters::BaseFormatter

  attr_reader :output_hash

  def self.default_output
    output_dir = ENV['FAILED_FORMATTER_OUTPUT'] || 'tmp'
    output_file = "component_failures#{ENV['TEST_ENV_NUMBER']}"
    "#{output_dir}/#{output_file}.json"
  end

  def initialize(output)
    default_file = File.open(self.class.default_output, 'w')
    super(default_file)
    @output_hash = {}
  end

  def message(message)
    (@output_hash[:messages] ||= []) << message
  end

  # intentionally turn dump_summary into a no-op
  def dump_summary(duration, example_count, failure_count, pending_count)
  end

  def stop
    super
    
    time_all_examples = ENV['TIME_ALL_EXAMPLES']
    
    @output_hash[:examples] = examples.select do |example|
      if time_all_examples
        true
      else
        example.execution_result[:status] == "failed"
      end
    end.map do |example|
      addl_standard_keys = Array(ENV["RSPEC_META_KEYS"].to_s.split(",")).compact.map(&:to_sym)

      standard_metadata_keys = [:example_group, :example_group_block,
                                :block, :description_args, :type,
                                :caller, :execution_result, :full_description,
                                :line_number, :file_path, :description,
                                :described_class, :location] +
                                addl_standard_keys
      tags = example.metadata.keys - standard_metadata_keys
      {
        :tags => tags,
        :description => example.description,
        :full_description => example.full_description,
        :status => example.execution_result[:status],
        :file_path => example.metadata[:file_path],
        :line_number  => example.metadata[:line_number],
      }.tap do |hash|
          if e=example.exception
            hash[:exception] =  {
              :class => e.class.name,
              :message => e.message,
              :backtrace => e.backtrace,
            }
          end
        end
    end
  end

  def close
    output.write @output_hash.to_json
    output.close if IO === output && output != $stdout
  end

end

