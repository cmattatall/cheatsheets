
# Add this to your bashrc


function python_env_init() {
  if [ -f requirements.txt ]; then
    if [ $(dpkg --list | grep env | grep virtual | grep python | awk '{print $2}')  -eq "python3-virtualenv" ]; then
      virtualenv -p /usr/bin/python3 venv
      source venv/bin/activate
      python -m pip install -r requirements.txt
    else
      echo "python3-virtualenv does not seem to be installed. Please install it first"
    fi
  else
    echo "No requirements.txt file present in the current directory"
  fi
}


# Initializes an AWS cdk stack project (python)
# and sources a python virtual environment
function cdk_python_env_init() {
  if [ -f requirements.txt ]; then
    if [ $(dpkg --list | grep env | grep virtual | grep python | awk '{print $2}')  -eq "python3-virtualenv" ]; then
      if [ $(which cdk) -eq 0 ]; then
        cdk init app --language python
        source venv/bin/activate
        python -m pip install -r requirements.txt
      else
        echo "program \"cdk\" not found on disk, please install it first"
      fi
         else
      echo "python3-virtualenv does not seem to be installed. Please install it first"
    fi
  else
    echo "No requirements.txt file present in the current directory"
  fi
}

