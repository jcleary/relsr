require 'yaml'
require 'optparse'

module Relsr
  class Initializer

    YAML_FILE = '.relsr.yml'

    def self.init
      parse_options
      parse_yaml
      process
    end

    private

    def self.parse_options 
      @options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: relsr [options]"

        opts.on("-r", "--release", "Create a release branch and open a pull request") do |v|
          @options[:branch] = true 
          @options[:pull_request] = true 
        end

        opts.on("-b", "--branch", "Create a release branch only") do |v|
          @options[:branch] = true 
        end

        opts.on("-d", "--dry-run", "Dry run") do |v|
          @options[:dry_run] = true 
        end

        opts.on("-i", "--init", "Create #{YAML_FILE} for project") do |v|
          create_default_yaml
          exit 0
        end
      end.parse!
    end

    def self.parse_yaml
      unless File.exists?(YAML_FILE)
        puts "Could not file #{YAML_FILE} file."
        exit 1
      end
      begin
        config = YAML.load_file(YAML_FILE)
        raise 'repo: has not been set' if config['repo'].nil?
        raise 'label: has not been set' if config['label'].nil?
        @repo = config['repo']
        @label = config['label']
      rescue StandardError => error
        puts "invalid #{YAML_FILE} file"
        puts error.message
        exit 1
      end
    end

    def self.process
      manager = Relsr::ReleaseManager.new(@repo, @label, @options[:dry_run])
      manager.create_release if @options[:branch]
      manager.create_pull_request if @options[:pull_request]
    end

    def self.create_default_yaml
      content = {
       'repo' => 'username/repo_name',
       'label' => 'acceptance-done'
      }
      File.open(YAML_FILE, 'w') {|f| f.write content.to_yaml }
    end
  end

end
