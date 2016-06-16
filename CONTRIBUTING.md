# Contributing


Contributions will be greatly appreciated. You're welcome to submit [pull requests](https://github.com/simplabs/rails_api_auth/pulls), [propose features and discuss issues](https://github.com/simplabs/rails_api_auth/issues).

## Fork the Project

Fork the [project on Github](https://github.com/simplabs/rails_api_auth) and check out your copy.

```
git clone https://github.com/contributor/rails_api_auth.git
cd rails_api_auth
git remote add upstream https://github.com/simplabs/rails_api_auth.git
```

## Create a Topic Branch

Make sure your fork is up-to-date and create a topic branch for your feature or bug fix.

```
git checkout master
git pull upstream master
git checkout -b my-feature-branch
```

## Write Tests

Try to write a test that reproduces the problem you're trying to fix or describes a feature that you want to build. Add to [spec/](spec/).

I also appreciate pull requests that highlight or reproduce a problem, even without a fix.

## Write Code

Implement your feature or bug fix. Please be sure to submit clean, well refactored code.

## Commit Changes

Make sure git knows your name and email address:

```
git config --global user.name "Your Name"
git config --global user.email "contributor@example.com"
```

Writing good commit logs is important. A commit log should describe what changed and why.

```
git add ...
git commit
```

## Push

```
git push origin my-feature-branch
```

## Make a Pull Request

Rebase with upstream/master.

```
git fetch upstream
git rebase upstream/master
git push origin my-feature-branch -f
```

(If you have several commits, please [squash them](http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html) into a single commit with `git rebase -i`)

Go to https://github.com/contributor/rails_api_auth and select your feature branch. Click the 'Pull Request' button and fill out the form. 

If you're new to Pull Requests, check out the [Github docs](https://help.github.com/articles/using-pull-requests)

## Thank You

Any contribution small or big is greatly appreciated. Thank you.
