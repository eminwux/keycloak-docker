# keycloak-docker

## Introduction
This project sets up Keycloak with Docker using a PostgreSQL database. Keycloak is an open-source Identity and Access Management solution aimed at modern applications and services.

## Requirements
* Docker
* Docker Compose

## Configuration
Before running the application, ensure the environment variables in the `docker-compose.yaml` file are set correctly. Adjust the values for the database connection and Keycloak admin account as needed.

## Build and Run
Use Docker Compose to build and run the services:

```bash
docker-compose up --build
```
This command will pull the necessary Docker images, build the Keycloak image, and start the services as defined in `docker-compose.yaml`.

## Accessing Keycloak
Once the containers are running, Keycloak will be accessible via:

HTTP: http://localhost or http://localhost.localdomain (or host defined in KC_DOMAIN)
HTTPS: https://localhost or https://localhost.localdomain (or host defined in KC_DOMAIN)

Remember to add `localhost.localdomain` or whatever value you define in `/etc/hosts`. Otherwise, the server will be up and configured but you won't be able to access.

Log in using the admin username and password specified in the `docker-compose.yaml`.

## Volumes
The project uses Docker volumes to persist Keycloak data and scripts:

* ./keycloak/volumes/scripts/: Contains custom entrypoint scripts.
* ./keycloak/volumes/data/: Used for persisting Keycloak data: server.keystore (private TLS key) and server.crt (certificate, self-signed public TLS key)

The goal of mounting these files is making it easy to modify them without having to re build.

## Customization
You can customize the configurations by modifying the entrypoint.sh script or by changing the environment variables in `docker-compose.yaml`.

## Security
For production environments, ensure you:

Change the default passwords.
Configure SSL properly if exposing Keycloak externally.
Review the PostgreSQL JDBC connection parameters and uncomment the JDBC_PARAMS in `docker-compose.yaml` to use SSL or other security features.


## Troubleshooting
For any issues regarding the Docker containers or Keycloak setup, consult the logs using:

```bash
docker logs keycloak
```
This command will help you diagnose issues by viewing error messages and other log outputs.

# License
This project is licensed under the MIT License. See the LICENSE file for more details.

# Contributing
Contributions are welcome! Please submit a pull request or open an issue to discuss any changes or improvements.
For any questions or support, please contact [eminwux at famous-google-mail-service].

