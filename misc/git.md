
## delete branch 
git push origin --delete NAME     # remote branch
git branch -d localBranchName     # local branch

## SQUASH
https://stackoverflow.com/questions/5189560/squash-my-last-x-commits-together-using-git


## force "git pull" to overwrite local files
```
# First, run a fetch to update all origin/<branch> refs to latest:	
git fetch --all
# Backup your current branch:											
git branch backup-master
# Then...
git reset --hard origin/<branch_name>
```

## Changing a commit message
git commit --amend


## drop last commit
git reset --hard HEAD^


## rebase
git rebase --onto master branch_one branch_two


# git gone

In order to remove local branches that do not exist in remote repo, add the following alias to *.gitconfig* file and executes *git gone* command.

```
[alias]
    gone = ! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" {print $1}' | xargs git branch -D
```

Remove local obsolete directories
`git clean -dfx`