require 'octokit'
Octokit.auto_paginate = true

class ReleaseManager

  def initialize(repo_name, label)
    @repo_name = repo_name
    @label = label
  end

  def create_release
    client.create_ref(@repo_name, "heads/#{release_branch_name}", master.object.sha)
    merge_branches
  end

  def create_pull_request
  end

  private

  def release_branch_name
    @release_branch_name ||= Time.now.strftime('release/%Y%m%d-%H%M%S')
  end

  def create_release_branch
    master = client.refs(@repo_name, 'heads/master')
    client.create_ref(@repo_name, "heads/#{release_branch_name}", master.object.sha)
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

  def merge_branches
    branches_to_merge.each do |work_branch|
      puts work_branch
      puts release_branch_name
      next
      client.merge(
        @repo_name, 
        release_branch_name, 
        work_branch, 
        commit_message: "Merging #{work_branch} into release"
      )
    end
  end

  def branches_to_merge
    branches_to_merge = []

    issues = client.list_issues(@repo_name, labels: @label )
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

end
