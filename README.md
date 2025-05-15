# BobApp

## Quality status

| Frontend                                                                                                                                                                                                                                                                                                              | Backend                                                                                                                                                                                                                                                                                                             |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend) | [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend) |
| [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend)                       | [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend)                       |
| [![Bugs](https://sonarcloud.io/api/project_badges/measure?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend&metric=bugs)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend)                          | [![Bugs](https://sonarcloud.io/api/project_badges/measure?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend&metric=bugs)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend)                      |
| [![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend)            | [![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend)        |
| [![Coverage](https://sonarcloud.io/api/project_badges/measure?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend&metric=coverage)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Backend)                  | [![Coverage](https://sonarcloud.io/api/project_badges/measure?project=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend&metric=coverage)](https://sonarcloud.io/summary/new_code?id=kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD-Frontend)              |

## Installation

Clone project:

```sh
git clone https://github.com/Kwaadpepper/Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD.git
```

## Front-end

Go inside folder the front folder:

```sh
cd front
```

Install dependencies:

```sh
npm install
```

Launch Front-end:

```sh
npm run start
```

## Back-end

Go inside folder the back folder:

```sh
cd back
```

Install dependencies:

```sh
mvn clean install
```

Launch Back-end:

```sh
mvn spring-boot:run
```

Launch the tests:

```sh
mvn clean install
```

## Run with Docker

*Important :* The backend should be started before the front for the nginx `proxypass` to succeed.

### Create the network

```sh
docker network create bobapp
```

This network should host both backend and frontend.

### Backend

Either

#### Run directly the container

```sh
docker run --network bobapp -p 8080:8080 --name bobapp-back juniko/bobapp-back:latest
```

Or

#### Build the backend container

```sh
docker build -t bobapp-back .
```

#### Start the backend container

```sh
docker run --network bobapp -p 8080:8080 --name bobapp-back -d bobapp-back
```

### Frontend

Either

```sh
docker run --network bobapp -p 8081:80 --name bobapp-front juniko/bobapp-front:latest
```

Or

#### Build the frontend container

```sh
docker build -t bobapp-front .
```

#### Start the frontend container

```sh
docker run --network bobapp -p 8081:80 --name bobapp-front -d bobapp-front
```

**NOTE**: `bobapp-back` is mentioned in `/front/nginx.conf` as proxy pass. So you should change this or make sure the backend container is run with the `--name bobapp-back` option and that both are running with the `--network bobapp` option.
