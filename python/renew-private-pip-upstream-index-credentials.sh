#!/bin/bash
# Bash script to renew private pypi credentials for a pypi repo hosted on
# AWS CodeArtifact
# 
# Place this script somewhere that DOESNT require sudo e.g. ~/.local/bin/
#
# This script requires awscli installed with a profile called rimot-software-packages-downloader
echo "Renewing pypi credentials for rimot-codeartifact-repo"
which pip > /dev/null
if [ "0" -eq "0" ]; then
    which aws > /dev/null
    if [ "0" -eq "0" ]; then
        # Set the upstream but preserve the previous upstream as an extra
        aws \
            --profile rimot-software-packages-downloader \
            --region us-east-1 \
            codeartifact login \
              --domain rimot-codeartifact-domain \
              --repository rimot-codeartifact-repo \
              --tool pip \
        && pip config set global.extra-index-url https://pypi.org/simple
    else
        echo "awscli is not installed, cannot configure credentials for rimot-codeartifact pypi upstreams"
    fi
else
    echo "pip is not installed, cannot configure credentials for rimot-codeartifact pypi upstreams"
fi
