[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD)

[![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD)](https://sonarcloud.io/summary/new_code?id=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD)

[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD&metric=bugs)](https://sonarcloud.io/summary/new_code?id=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD)

[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD)

[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD&metric=coverage)](https://sonarcloud.io/summary/new_code?id=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD)

[![SonarQube Cloud](https://sonarcloud.io/images/project_badges/sonarcloud-light.svg)](https://sonarcloud.io/summary/new_code?id=Kwaadpepper_Gerez-un-projet-collaboratif-en-int-grant-une-demarche-CI-CD)

# BobApp

Clone project:

> git clone XXXXX

## Front-end 

Go inside folder the front folder:

> cd front

Install dependencies:

> npm install

Launch Front-end:

> npm run start;

### Docker

Build the container:

> docker build -t bobapp-front .  

Start the container:

> docker run -p 8080:8080 --name bobapp-front -d bobapp-front

## Back-end

Go inside folder the back folder:

> cd back

Install dependencies:

> mvn clean install

Launch Back-end:

>  mvn spring-boot:run

Launch the tests:

> mvn clean install

### Docker

Build the container:

> docker build -t bobapp-back .  

Start the container:

> docker run -p 8080:8080 --name bobapp-back -d bobapp-back 