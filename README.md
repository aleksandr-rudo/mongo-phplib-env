# MongoDB PHP Library development environment

This environment helps to start work on MongoDB PHP Library project.

## Setup environment

    $ git clone https://github.com/aleksandr-rudo/mongo-phplib-env.git
    $ cd mongo-phplib-env


1. Fork your own projects in GitHub, which you will work with
2. Copy file .env.dist to the .env
3. Write your forked links for LIBRARY_REPO, DRIVER_REPO, SPECIFICATIONS_REPO, COMPASS_REPO if needed (there are common MongoDB links by default)
4. Build docker container and run it:

## Build Docker container

    $ docker-compose build

## Run Docker container

    $ docker-compose up -d

After all mongo containers started the "mongosetup" container will configure theirs replica set in 40 seconds.

## Containers

1. "mongo400" - Container with MongoDB v.4.0
2. "mongo440" - Container with MongoDB v.4.4
3. "mongo500" - Container with MongoDB v.5.0
4. "mongo506" - Container with MongoDB v.5.0.6
5. "mongo508" - Container with MongoDB v.5.0.8
6. "mongo530" - Container with MongoDB v.5.3
7. "mongo600" - Container with MongoDB v.6.0
8. "mongosetup" - Container which setup the replicaset for all MongoDB containers
9. "php80" - Container with PHP 8.0 (with all development data)
10. "php80wmongo" - Container with PHP 8.0 (with all development data) with MongoDB onboard (some MongoDB features, like mongocryptd, requires MongoDB to be installed on the same instance)

The development data is mounted in the containers from "dev" directory as volume so there is no necessity to set development data for each PHP container separately.

## Projects checkout and setup

Containers "php80" and "php80wmongo" are identic (just with or without MongoDB) and thow you can work in any of these two containers.

To start your development go to the development container ("php80" or "php80wmongo") and run installation script:

    $ bash install_environment.sh

This will install and configure 4 projects [PHP Library](https://github.com/mongodb/mongo-php-library.git), [PHP Driver](https://github.com/mongodb/mongo-php-driver.git), [MongoDB Specifications](https://github.com/mongodb/specifications.git), [MongoDB Compass](https://github.com/aleksandr-rudo/compass.git). For Driver it will be not only checked out but it will be built (making mongodb.so PHP module) by this script. The only thing you will need to do is to edit phpunit.xml file and to setup the correct MongoDB URI, for example:

````
<env name="MONGODB_URI" value="mongodb://mongo600:27017/?serverSelectionTimeoutMS=30&amp;replicaset=rs0"/>
````

Note: Each development container should build PHP Driver separately.

Note: Each time you restart your container you need to rebuild PHP Driver.

## Other development scripts

To rebuild PHP Driver in case you restart development container for example, you can use script:

    $ bash setup.sh

To reinstall some development project (in case, when you change project repository or some other cases) you can remove old directory and use one of the following scripts:

    $ bash install_library.sh
    $ bash install_driver.sh
    $ bash install_specifications.sh
    $ bash install_compass.sh

## Projects special scripts

Each project contains some special scripts, for common actions

### PHP Library project special scripts

Run tests:

    $ cd library
    $ bash test.sh --filter SomeFilter

Run tests on all available MongoDB instances one by one:

    $ cd library
    $ bash test_global.sh --filter SomeFilter

Run the project code check:

    $ cd library
    $ bash check.sh

Run the project code autofix:

    $ cd library
    $ bash fix.sh

### PHP driver project special scripts

Run the current project build (building MongoDB Driver):

    $ cd driver
    $ bash build.sh

The difference with setup.sh script is that the setup.sh is checking out the master branch of the current repository to build the driver. Current script works with the current project state.

### MongoDB Compass project special scripts

Run the preparation for BSON-Transpilers development

    $ cd compass
    $ bash setup.sh
