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
      @options = {
        dry_run: false,
        extra_branches: []
      }
      OptionParser.new do |opts|
        opts.banner = "Usage: relsr [options]"

        opts.on("-r", "--release", "Create a release branch and open a pull request") do 
          @options[:release_branch] = true 
          @options[:pull_request] = true 
        end

        opts.on("-b", "--branch", "Create a release branch only") do 
          @options[:release_branch] = true 
        end

        opts.on("-a", "--add BRANCH", "Add a branch to the release") do |v|
          @options[:extra_branches] << v 
        end

        opts.on("-d", "--dry-run", "Dry run") do 
          @options[:dry_run] = true 
        end

        opts.on("-i", "--init", "Create #{YAML_FILE} for project in the current folder") do 
          create_default_yaml
          exit 0
        end

        opts.on("-v", "--version", "Get version information") do 
          version_info
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
        @options[:extra_branches] += config['add_branches'] if config.key? 'add_branches'

      rescue StandardError => error
        puts "invalid #{YAML_FILE} file"
        puts error.message
        exit 1
      end
    end

    def self.process
      manager = Relsr::ReleaseManager.new(
        repo_name: @repo, 
        label: @label, 
        dry_run: @options[:dry_run], 
        extra_branches: @options[:extra_branches]
      )
      manager.create_release_branch if @options[:release_branch]
      manager.create_pull_request if @options[:pull_request]
    end

    def self.create_default_yaml
      content = {
       'repo' => 'username/repo_name',
       'label' => 'acceptance-done'
      }
      File.open(YAML_FILE, 'w') {|f| f.write content.to_yaml }
    end

    def self.version_info
      puts "Relsr version #{Relsr::VERSION}"
    end
  end

end
