#!/bin/bash

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to echo in green
echo_green() {
    echo -e "${GREEN}$1${NC}"
}

echo_red() {
    echo -e "${RED}$1${NC}"
}

ok_or_exit(){
    if [ $? -ne 0 ];then
        echo_red "Something went wrong, shutting down... $?"
        exit 1
    fi
}

# Function to check if required environment variables are set
check_env_var() {
    if [ -z "${!1}" ]; then
        echo -e "${NC}Error: Environment variable $1 is not set.${NC}" >&2
        exit 1
    fi
}

delete_file(){
    rm $1 2>/dev/null || true
}

check_env_var "KC_HOSTNAME"

if [ ! -f /mnt/keycloak/server.keystore ]; then
    
    cd /mnt/keycloak/

    delete_file /mnt/keycloak/server.keystore 
    delete_file /mnt/keycloak/server.crt 
    delete_file /opt/keycloak/conf/server.keystore

    # Generate key pair for server
    echo_green "Generating key pair..."
    keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1,DNS:$KC_HOSTNAME" -keystore server.keystore

    ok_or_exit

    # Link server.keystore to the Keycloak configuration directory
    echo_green "Linking keystore..."
    ln -s `pwd`/server.keystore /opt/keycloak/conf/
    ok_or_exit

    # Export the public certificate from keystore
    echo_green "Exporting certificate..."
    keytool -exportcert -alias server -file server.crt -keystore server.keystore -storepass password -rfc
    ok_or_exit

    # Build Keycloak configurations
    echo_green "Building Keycloak configuration..."
    /opt/keycloak/bin/kc.sh build
    ok_or_exit

    echo_green "Displaying Keycloak configuration..."
    /opt/keycloak/bin/kc.sh show-config
    ok_or_exit

fi

# Start Keycloak with development settings and log level info
echo_green "Starting Keycloak..."
/opt/keycloak/bin/kc.sh start-dev --log-level=info
ok_or_exit