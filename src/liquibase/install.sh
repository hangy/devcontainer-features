#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Jed Laundry 2022, hangy 2024. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Based on https://github.com/jlaundry/devcontainer-features/blob/c60daca0afc1de7d9c5d28fc07d371b9483ec28e/src/mssql-odbc-driver/install.sh


set -e

# Clean up
rm -rf /var/lib/apt/lists/*

LIQUIBASE_VERSION=${VERSION:-"latest"}

LIQUIBASE_GPG_KEYS_URI="https://repo.liquibase.com/liquibase.asc"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            echo "Running apt-get update..."
            apt-get update -y
        fi
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive


install_using_apt() {
    # Install dependencies
    check_packages apt-transport-https curl ca-certificates gnupg2 dirmngr
    # Import key safely (new 'signed-by' method rather than deprecated apt-key approach) and install
    curl -sSL ${LIQUIBASE_GPG_KEYS_URI} | gpg --dearmor > /usr/share/keyrings/liquibase-keyring.gpg

    echo "deb [arch=${architecture} signed-by=/usr/share/keyrings/liquibase-keyring.gpg] https://repo.liquibase.com stable main" > /etc/apt/sources.list.d/liquibase.list
    apt-get update

    if [ "$LIQUIBASE_VERSION" = "latest" ]; then
        apt-get install -y liquibase
    else
        apt-get install -y liquibase= ${LIQUIBASE_VERSION}
    fi
}

echo "(*) Installing Liquibase CLI..."
. /etc/os-release
architecture="$(dpkg --print-architecture)"

install_using_apt

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
