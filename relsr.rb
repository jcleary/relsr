require_relative 'release_manager'

manager = ReleaseManager.new('CorporateRewards/myrewards', 'status: acceptance - done')
manager.create_release
manager.create_pull_request














