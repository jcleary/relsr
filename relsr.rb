require_relative 'release_manager'

dry_run = false
manager = ReleaseManager.new('CorporateRewards/myrewards', 'status: acceptance - done', dry_run)
manager.create_release
manager.create_pull_request














