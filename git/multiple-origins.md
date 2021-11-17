


# HOW TO ADD MULTIPLE PUSH REMOTES TO A SINGLE REPOSITORY

** Note the order of adding the extra origins. **
** The first invocation of set-url is NOT for the URL that was used when adding the origin. **
** Note: It is not possible to configure multiple fetch/pull upstreams. **

```sh
$git remote remove origin
$git remote remove1 origin
$git remote remove2 origin

$git remote add remote1 <MY_REMOTE_1_URL>
$git remote add remote2 <MY_REMOTE_2_URL>
$git remote add origin <MY_REMOTE_1_URL> 
$git remote set-url --add --push origin <MY_REMOTE_2_URL> 
$git remote set-url --add --push origin <MY_REMOTE_1_URL> 
$git branch --set-upstream-to=origin/master master
```

