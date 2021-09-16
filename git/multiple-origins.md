
HERE IS HOW TO ADD MULTIPLE ORIGINS TO A SINGLE GIT REPO.

$git remote remove origin
$git remote add origin git@bitbucket.org:rimot-io/cloudcomm.git
$git remote set-url --add --push origin git@bitbucket.org:rimot-io/cloudcomm.git
$git remote set-url --add --push origin http://bitbucket.nautel.com:7990/scm/titan/cloudcomm.git


