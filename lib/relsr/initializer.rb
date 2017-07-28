require 'yaml'
require 'thor'

module Relsr
  class Initializer < Thor

    YAML_FILE = '.relsr.yml'

    desc 'release', 'Create a release branch and open a pull request'
    option :'dry-run', type: :boolean, aliases: '-d'
    option :'no-pr', type: :boolean, desc: "Don't create the pull request", default: false
    option :add, desc: 'additional branches to add to the release', type: :array
    def release
      manager = release_manager
      manager.create_release_branch
      manager.create_pull_request unless options['no-pr']
    end

    desc 'init', "Create default #{YAML_FILE} in the current folder"
    def init
      create_default_yaml
    end

    private

    def parse_yaml
      unless File.exist?(YAML_FILE)
        puts "Could not file #{YAML_FILE} file."
        exit 1
      end
      begin
        config = YAML.load_file(YAML_FILE)
        raise 'repo: has not been set' if config['repo'].nil?
        raise 'label: has not been set' if config['label'].nil?
        @repo = config['repo']
        @label = config['label']
        @extra_branches += config['add_branches'] if config.key? 'add_branches'

      rescue StandardError => error
        puts "invalid #{YAML_FILE} file"
        puts error.message
        exit 1
      end
    end

    def release_manager
      @extra_branches = options['add'].to_a
      parse_yaml

      Relsr::ReleaseManager.new(
        repo_name: @repo, 
        label: @label, 
        dry_run: options['dry-run'], 
        extra_branches: @extra_branches.uniq
      )
    end

    def create_default_yaml
      content = {
       'repo' => 'username/repo_name',
       'label' => 'acceptance-done'
      }
      File.open(YAML_FILE, 'w') {|f| f.write content.to_yaml }
    end
  end
end

