

# REMOVING A SPECIFIC COMMIT THAT IS NOT HEAD

Rebase (show the log of the last 5 commits and delete the lines you don't want, or reorder, or squash multiple commits in one, or do anything else you want, this is a very versatile tool):

```sh
git rebase -i HEAD~5
```


And if a mistake is made:

```sh
git rebase --abort
```
