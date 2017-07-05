# Relsr

**relsr** is a command line tool for GitHub release management. 

## tl;dr
If you use GitHub labels to identify features that are ready to ship, you can use **relsr** to build a branch and pull-request for your deployment.

## How it works
**relsr** connects to the GitHub API and finds all open issues with a given label (configurable). Then, using those issues numbers it pulls toggether all 
feature branches that have `#issue-no` in the name and merges them into a new release branch. **relsr** can also create a pull request for the release.


## Relsr Workflow
In order to use relsr, you will need to follow the Relsr Workflow:

- feature branches and bug fixes should all branch from master.
- feature branches have to contain a hash followed by the issue number, e.g. `feature/#1234-super-cool-feature`
- when features are finished the feature branch can be merged into develop for manual testing or acceptance.
- once a feature has been accepted it is given a GitHub lable that identifies it as ready to deploy.
- use **relsr** to build a release bracnh from accepted issues.

The only gotcha with this workflow is that if someone pushes directly to develop it may never be deployed. 
To mitigate this risk you can do one or more of the following:
- protect the develop branch and enfore that all merges are via a pull request.
- periodically merge everything from develop to the release branch.
- cherry pick commits from develop into the release branch.

## Getting started
Install the gem as follows:
```bash
gem install relsr
```

Then, in your project folder run the initializer:
```bash
relsr --init
```

This will create a file called `.relsr.yml` in the current folder which you will need to edit. Here is an example:
```yaml
---
repo: 'CreatekIo/my-app'
label: 'status: deploying'
```

**relsr** uses settings from your `.netrc` file to connect to GitHub. If you have not already done so, create a GutHub Personal access token and enter the details into your `.netrc` file:
```
machine api.github.com
  login github_username
  password personal_access_token
```
## Creating a release
To confirm that you have configured everything correctly you can perform a dry-run like so:
```bash
relsr -dr
```

If all is well you should see something like this:
```
Creating release branch 'release/20170704-205514' on 'jcleary/relsr'...done
Merging 'feature/#1234-super-cool-feature' into release...done
Merging 'feature/#5678-tricky-bug-fix' into release...done
Creating Pull Request...done
``` 

Once you are ready, you can create the branch and pull request:
```
relsr -r
```

Enjoy!



