require 'thor'
require 'rugged'

module Relsr
  class Issue < Thor

    desc 'checkout ISSUE_NO', 'Checkout an issue locally. Creates a new branch if required'
    def checkout(issue)
      local_branch_for(issue) || remote_branch_for(issue)
    end

    map co: :checkout

    private 

    def local_branch_for(issue)
      git.branches.each(:local) do |branch|
        if branch.name.start_with? "feature/##{issue}-"
          puts "Checking out local branch '#{branch}'".green
          git.checkout(branch.name)
          return true
        end
      end
      false
    end

    def remote_branch_for(issue)
      git.fetch('origin')
      return
      git.branches.each(:remote) do |branch|
        local_name = branch.name[branch.remote_name.size+1..-1]
        if local_name.start_with? "feature/##{issue}-"
          puts "Checking out and tracking remote branch '#{local_name}'".green
          new_branch = git.branches.create(local_name, branch.name)
          new_branch.upstream = branch
          git.checkout(local_name)
          return true
        end
      end
      false
    end

    def git
      @git ||= Rugged::Repository.new(Dir.pwd)
    end

    def fetch
      puts "fetching..."
      git.remotes.each { |remote| remote.fetch }
    end
  end
end
