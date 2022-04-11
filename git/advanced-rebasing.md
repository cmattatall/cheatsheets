

# I want to restore a file that was deleted N commits ago.

```sh
git checkout HEAD~N
git rebase -i HEAD~<N+1>
<CHANGE "pick" to "edit" for the commit with the deleted file. Then save and close the interactive rebase config >
git checkout HEAD^ <YOUR_FILE>
git add <YOUR_FILE>
git commit --amend --no-edit
git rebase --continue
```