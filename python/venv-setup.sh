
# Add this to your bashrc

function python_env_init() {
    dpkg --list | grep env | grep virtual | grep python | awk '{print $2}' > /dev/null
    if [ "$?" -eq "0" ]; then
        which virtualenv
        if [ "$?" -eq "0" ]; then
            $(which virtualenv) -p /usr/bin/python3 venv
            source venv/bin/activate
            if [ -f requirements.txt ]; then
                echo "Found requirements.txt file. Installing python packages now..."
                python -m pip install -r requirements.txt
                if [ "$?" -eq "0" ]; then
                    echo "Ok."
                else
                    echo "Error installing python packages from requirements.txt"
                fi
            else
                echo "No requirements.txt file present in the current directory"
            fi
        else
            echo "Could not find virtualenv executable in PATH"
        fi
    else
        echo "python3-virtualenv does not seem to be installed. Please install it first"
    fi
}


# Initializes an AWS cdk stack project (python)
# and sources a python virtual environment
function cdk_python_env_init() {
    dpkg --list | grep env | grep virtual | grep python | awk '{print $2}' > /dev/null
    if [ "$?" -eq "0" ]; then
        echo "Looking for cdk ... "
        which cdk > /dev/null
        if [ "$?" -eq "0" ]; then
            $(which cdk) init app --language python
            source .venv/bin/activate
            if [ -f requirements.txt ]; then
                python -m pip install -r requirements.txt
                if [ "$?" -eq "0" ]; then
                    echo "Ok."
                else
                    echo "Error installing python packages from requirements.txt"
                fi
            else
                echo "No requirements.txt file found! Could not install python packages"
            fi
        else
            echo "program \"cdk\" not found on disk, please install it first"
        fi
    else
        echo "python3-virtualenv does not seem to be installed. Please install it first"
    fi
}
