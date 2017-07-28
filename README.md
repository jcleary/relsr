# Relsr

**relsr** is a command line tool for GitHub release management. 

## tl;dr
If you use GitHub labels to identify features that are ready to be shipped, you can use **relsr** to manage your release workflow.

## How it works
**relsr** connects to the GitHub API and finds all open issues with a given label (configurable). Then, using those issues numbers it pulls toggether all 
feature branches that have `#issue-no` in the branch name and merges them into a new release branch. **relsr** can also create a pull request for the release.


## Relsr Workflow
In order to use relsr, you will need to follow the Relsr Workflow:

- feature branches and bug fixes must all have branched from master.
- feature branche names have to contain a hash followed by the issue number, e.g. `feature/#1234-super-cool-feature`
- when features are finished, the feature branch can be merged into develop for manual testing / acceptance.
- once a feature has been accepted it is given a GitHub lable that identifies it as being ready to deploy.
- now you can use **relsr** to build a release branch from accepted issues.


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

**relsr** uses settings from your `.netrc` file to connect to GitHub. If you have not already done so, create a GutHub Personal Access Token and enter the details into your `.netrc` file:
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
## Q and As
**I sometimes push directly to `develop`, but these commits are not being deployed, what should I do?**

You can either cherry-pick the commits into your next release or into a feature branch that is about to be release.

---

**I've got a branch that I want to be included in the next release, but it does not belong to a ticket, how can I include it?**

The easiest way is to use the `-a` option for adding branches, e.g.: 
```
relst -d -a hotfix/server-config
```
---
**I have a branch that receives commits from an external service (such as a translation management tool). Is it possible to include this branch in every release?** 

Yes. You can update the `relst.yaml` file and include the name of the branch (or branches) in the `add_branches:` section, e.g.
```yaml
repo: CreatekIo/my-app
lable: 'status: deploying'
add_branches:
  - i18n/updates
  - another_branch
```
---


Enjoy!



