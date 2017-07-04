# Relsr

**relsr** is a command line tool for GitHub release management. 

## tl;dr
If you use GitHub labels to identify features that are ready to be shipped, you can use **relsr** to build a branch and pull-request for your deployment.

## How it works
**relsr** connects to the GitHub API and finds all open issues with a given label (configurable). Then, using those issues numbers it pulls toggether all 
feature branches that have `#issue-no` in the name and merges them into a new release branch. **relsr** can also create a pull request for the release.

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

## Creating a release
To check you have configured everything correctly you can perform a dry-run like so:
```bash
relsr -dr
```

If you have done everything correctly, you should see something like this:
```
Creating release branch 'release/20170704-205514' on 'jcleary/relsr'...done
Creating Pull Request...done
``` 

Once you are ready, you can create the branch and pull request:
```
relsr -r
```

Enjoy!



