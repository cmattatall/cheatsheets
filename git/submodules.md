
BEST WAY TO REMOVE A GIT SUBMODULE


1. Deinitialize the submodule `git submodule deinit -f <submodule-name>`

2. Remove the submodule internally cached git subdirectory `rm -rf .git/modules/<submodule-name>`

3. Remove the submodule from your git modules config `git config --local -f .gitmodules --remove-section submodule.<submodule-name>`

4. Remove the submodule from your git config `git config --local -f .git/config --remove-section submodule.<submodule-name>`

5. Remove the git submodule from your git cache `git rm --cached <submodule-name>`

6. Commit the changes `git commit -m '[Remove] submodule: <submodule-name>'`



