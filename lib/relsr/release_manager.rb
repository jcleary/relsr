require 'octokit'
require 'colorize'

module Relsr
  class ReleaseManager

    def initialize(repo_name, label, dry_run = false)
      @repo_name = repo_name
      @label = label
      @release_branch_name = Time.now.strftime('release/%Y%m%d-%H%M%S')
      @dry_run = dry_run
      Octokit.auto_paginate = true
    end

    def create_release
      create_release_branch
      merge_work_branches
    end

    def create_pull_request
      print_and_flush "Creating Pull Request..."
      unless @dry_run
        client.create_pull_request(
          @repo_name,
          'master',
          @release_branch_name,
          @release_branch_name,
          pr_body
        )

      end
      puts 'done'.green
    end

    private

    def create_release_branch
      print_and_flush "Creating release branch '#{@release_branch_name}' on '#{@repo_name}'..."  
      unless @dry_run
        client.create_ref(@repo_name, "heads/#{@release_branch_name}", master.object.sha)
      end
      puts 'done'.green
    end

    def merge_work_branches
      branches_to_merge.each do |work_branch|
        print_and_flush "Merging '#{work_branch}' into release..."
        unless @dry_run
          client.merge(
            @repo_name, 
            @release_branch_name, 
            work_branch, 
            commit_message: "Merging #{work_branch} into release"
          )
        end
        puts 'done'.green
      end
    end

    def client
      @client ||= Octokit::Client.new(netrc: true)
    end

    def repo
      @repo ||= client.repo(@repo_name)
    end

    def branch_names
      @branch_names ||= client.branches(@repo_name).collect { |b| b.name }
    end

    def branches_to_merge
      branches_to_merge = []

      issues.each do |issue|
        branch_names.each do |branch|
          if branch.include? "##{issue.number}"
            branches_to_merge << branch
          end
        end
      end
      branches_to_merge
    end

    def master
      @master ||= client.refs(@repo_name, 'heads/master')
    end

    def issues
      @issues ||= client.list_issues(@repo_name, labels: @label)
    end

    def pr_body
      issues.collect do |issue|
        "Connects ##{issue.number} - #{issue.title}"
      end.join("\n")
    end

    def print_and_flush(msg)
      print msg
      STDOUT.flush
    end
  end
end
