#!/bin/bash

main() {
    ldt_parse $*
    ldt_load "${ldt_args[@]}"
    ldt_validate
    ldt_run
    if [ $? -ne 0 ]; then exit 500; fi
    exit 0
}

ldt_parse() {
    ldt_args=()

    for arg in "$@"; do
        case "$arg" in
        --debug)
            LDT_DEBUG=true
            ;;
        --email)
            LDT_VSCODE_EMAIL_FLAG=true
            ;;
        --installDocker)
            LDT_VSCODE_DOCKER=true
            ;;
        --installGit)
            LDT_VSCODE_GIT=true
            ;;
        --installOpenJdk)
            LDT_VSCODE_OPEN_JDK=true
            ;;
        --user)
            LDT_VSCODE_USER_FLAG=true
            ;;
        -c | --dockerCommand)
            LDT_DOCKER_COMMAND_FLAG=true
            ;;
        -d | --dockerDaemon)
            LDT_DOCKER_DAEMON=true
            ;;
        -i | --dockerImageTag)
            LDT_DOCKER_IMAGE_FLAG=true
            ;;
        -p | --dockerPort)
            LDT_DOCKER_PORT_FLAG=true
            ;;
        *)
            if [ "$LDT_DOCKER_COMMAND_FLAG" = "true" ]; then
                LDT_DOCKER_COMMAND_FLAG=false
                LDT_DOCKER_COMMAND=$arg
                continue
            fi
            if [ "$LDT_DOCKER_IMAGE_FLAG" = "true" ]; then
                LDT_DOCKER_IMAGE_FLAG=false
                LDT_DOCKER_IMAGE=$arg
                continue
            fi
            if [ "$LDT_DOCKER_PORT_FLAG" = "true" ]; then
                LDT_DOCKER_PORT_FLAG=false
                LDT_DOCKER_PORT=$arg
                continue
            fi
            if [ "$LDT_VSCODE_EMAIL_FLAG" = "true" ]; then
                LDT_VSCODE_EMAIL_FLAG=false
                LDT_VSCODE_EMAIL=$arg
                continue
            fi
            if [ "$LDT_VSCODE_USER_FLAG" = "true" ]; then
                LDT_VSCODE_USER_FLAG=false
                LDT_VSCODE_USER=$arg
                continue
            fi
            ldt_args+=($arg)
            ;;
        esac
    done
}

ldt_load() {
    ldt_logDebug "loading..."

    ldt_ctx=$1
    ldt_dockerContainerName=""
    ldt_dockerContainerNetwork=""
    ldt_dockerContainerUser=""
    ldt_dockerContainerEnv=""
    ldt_dockerContainerVolumes=""
    ldt_dockerContainerWorkdir=""
    ldt_dockerContainerPublish=""
    ldt_dockerContainerPort="$LDT_DOCKER_PORT"
    ldt_dockerContainerImage="$LDT_DOCKER_IMAGE"
    ldt_dockerContainerCommand="$LDT_DOCKER_COMMAND"
    ldt_me=$(whoami)
    ldt_sandbox=$2
    ldt_task=$3
    ldt_workindDir=$PWD

    if [ "$MYSQL_USER" = "" ]; then MYSQL_USER=mysql; fi
    if [ "$MYSQL_PASS" = "" ]; then MYSQL_PASS=my5qLLw; fi
    if [ "$PGADMIN_USER" = "" ]; then PGADMIN_USER=root@pgadmin.org; fi
    if [ "$PGADMIN_PASS" = "" ]; then PGADMIN_PASS=pg4dM1nLw; fi
    if [ "$POSTGRES_USER" = "" ]; then POSTGRES_USER=postgres; fi
    if [ "$POSTGRES_PASS" = "" ]; then POSTGRES_PASS=p0stgresLw; fi
    if [ "$RABBITMQ_USER" = "" ]; then RABBITMQ_USER=rabbitmq; fi
    if [ "$RABBITMQ_PASS" = "" ]; then RABBITMQ_PASS=r4bbitLmq; fi

    if [ -f $ldt_workindDir/ldtw.env ]; then
        export $(cat $ldt_workindDir/ldtw.env | xargs)
    fi

    ldt_logDebug "--> ldt_ctx=$ldt_ctx"
    ldt_logDebug "--> ldt_dockerContainerName=$ldt_dockerContainerName"
    ldt_logDebug "--> ldt_dockerContainerNetwork=$ldt_dockerContainerNetwork"
    ldt_logDebug "--> ldt_dockerContainerUser=$ldt_dockerContainerUser"
    ldt_logDebug "--> ldt_dockerContainerEnv=$ldt_dockerContainerEnv"
    ldt_logDebug "--> ldt_dockerContainerVolumes=$ldt_dockerContainerVolumes"
    ldt_logDebug "--> ldt_dockerContainerWorkdir=$ldt_dockerContainerWorkdir"
    ldt_logDebug "--> ldt_dockerContainerPublish=$ldt_dockerContainerPublish"
    ldt_logDebug "--> ldt_dockerContainerPort=$ldt_dockerContainerPort"
    ldt_logDebug "--> ldt_dockerContainerImage=$ldt_dockerContainerImage"
    ldt_logDebug "--> ldt_dockerContainerCommand=$ldt_dockerContainerCommand"
    ldt_logDebug "--> ldt_me=$ldt_me"
    ldt_logDebug "--> ldt_sandbox=$ldt_sandbox"
    ldt_logDebug "--> ldt_task=$ldt_task"
    ldt_logDebug "--> ldt_workindDir=$ldt_workindDir"

    ldt_logDebug "-- ---> MYSQL_USER=$MYSQL_USER"
    ldt_logDebug "-- ---> MYSQL_PASS=$MYSQL_PASS"
    ldt_logDebug "-- ---> PGADMIN_USER=$PGADMIN_USER"
    ldt_logDebug "-- ---> PGADMIN_PASS=$PGADMIN_PASS"
    ldt_logDebug "-- ---> POSTGRES_USER=$POSTGRES_USER"
    ldt_logDebug "-- ---> POSTGRES_PASS=$POSTGRES_PASS"
    ldt_logDebug "-- ---> RABBITMQ_USER=$RABBITMQ_USER"
    ldt_logDebug "-- ---> RABBITMQ_PASS=$RABBITMQ_PASS"

    ldt_logDebug "-- --- ---> DOCKER_DAMEON=$LDT_DOCKER_DAEMON"
}

ldt_validate() {
    ldt_logDebug "validating..."

    if [ "$ldt_ctx" = "" ]; then
        ldt_logError "context is required!"
        exit 400
    fi
    if [ ! "$ldt_ctx" = "docker" ]; then
        ldt_logError "context is invalid!"
        exit 400
    fi
    if [ "$ldt_sandbox" = "" ]; then
        ldt_logError "sandbox is required!"
        exit 400
    fi
    if [ ! "$ldt_sandbox" = "gradle" ] &&
        [ ! "$ldt_sandbox" = "mysql" ] &&
        [ ! "$ldt_sandbox" = "ng" ] &&
        [ ! "$ldt_sandbox" = "node" ] &&
        [ ! "$ldt_sandbox" = "pgadmin" ] &&
        [ ! "$ldt_sandbox" = "php" ] &&
        [ ! "$ldt_sandbox" = "php-fpm" ] &&
        [ ! "$ldt_sandbox" = "phpmyadmin" ] &&
        [ ! "$ldt_sandbox" = "postgres" ] &&
        [ ! "$ldt_sandbox" = "rabbitmq" ] &&
        [ ! "$ldt_sandbox" = "vscode" ] &&
        [ ! "$ldt_sandbox" = "webpack" ]; then
        ldt_logError "sandbox is invalid!"
        exit 400
    fi
    if [ ! "$ldt_task" = "backup" ] &&
        [ ! "$ldt_task" = "exec" ] &&
        [ ! "$ldt_task" = "postinstall" ] &&
        [ ! "$ldt_task" = "restore" ] &&
        [ ! "$ldt_task" = "run" ] &&
        [ ! "$ldt_task" = "start" ]; then
        ldt_logError "task is invalid!"
        exit 400
    fi
    if [ "$ldt_workindDir" = "" ]; then
        ldt_logError "working directory is required!"
        exit 400
    fi
    if [ ! -d "$ldt_workindDir" ]; then
        ldt_logError "working directory is invalid!"
        exit 400
    fi
}

ldt_run() {
    ldt_logDebug "preparing..."

    if [ "$ldt_ctx" = "docker" ]; then
        if [ "$ldt_sandbox" = "make" ]; then
            if [ "$ldt_task" = "watch" ]; then
                echo "TODO: ldtw docker make apt-get install -y inotify-tools"
                echo "TODO: ldtw docker make watch --codeChanges --with inotify-tools"
            fi
        fi
        if [ "$ldt_sandbox" = "gradle" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=gradle:latest
            fi
            if [ "$ldt_dockerContainerPort" = "" ]; then
                ldt_dockerContainerPort=9080
            fi
            ldt_logDebug "configure... 'gradle' sandbox"
            ldt_dockerContainerName="--name gradle"
            ldt_dockerContainerUser="-u $(id -u $ldt_me):$(id -g $ldt_me)"
            ldt_dockerContainerVolumes="-v $ldt_workindDir:/usr/src/app"
            ldt_dockerContainerWorkdir="-w /usr/src/app"
            ldt_dockerContainerPublish="-p $ldt_dockerContainerPort:9080"

            if [ "$ldt_task" = "start" ]; then
                ldt_dockerw_doDockerRun "sh -c \"gradle bootRun\""
            fi
            if [ "$ldt_task" = "exec" ]; then
                ldt_dockerw_doDockerRun "sh"
            fi
        fi
        if [ "$ldt_sandbox" = "mysql" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=mysql:latest
            fi
            ldt_logDebug "configure... 'mysql' sandbox"
            ldt_dockerContainerName="--name mysql"
            ldt_dockerContainerNetwork="--network mysql-net"
            ldt_dockerContainerEnv="-e MYSQL_ROOT_PASSWORD=$MYSQL_PASS -e MYSQL_DATABASE=mysql"
            ldt_dockerContainerVolumes="-v mysql_data:/var/lib/mysql"
            ldt_dockerContainerPublish="-p 3306:3306 -p 33060:33060"

            if [ "$ldt_task" = "start" ]; then
                ldt_dockerw_doDockerNetworkCheck mysql-net
                ldt_dockerw_doDockerVolumeCheck mysql_data
                ldt_dockerw_doDockerRun "mysqld --default-authentication-plugin=mysql_native_password"
            fi
            if [ "$ldt_task" = "backup" ]; then
                echo "TODO: ldtw docker mysql backup"
                ####     docker exec -i $containerName sh -c "exec mysqldump --host=${dbhost} --port=${dbport} --user=${dbuser} --password=${dbpass} ${dbname}" >$dumpfile
            fi
            if [ "$ldt_task" = "restore" ]; then
                echo "TODO: ldtw docker mysql restore"
                ####     docker exec -i $containerName sh -c "exec mysql --host=${dbhost} --port=${dbport} --user=${dbuser} --password=${dbpass} ${dbname}" <$dumpfile
            fi
        fi
        if [ "$ldt_sandbox" = "ng" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=node:latest
            fi
            if [ "$ldt_dockerContainerPort" = "" ]; then
                ldt_dockerContainerPort=4200
            fi
            ldt_logDebug "configure... 'ng' sandbox"
            ldt_dockerContainerName="--name angular"
            ldt_dockerContainerUser="-u $(id -u $ldt_me):$(id -g $ldt_me)"
            ldt_dockerContainerVolumes="-v $ldt_workindDir:/usr/src/app"
            ldt_dockerContainerWorkdir="-w /usr/src/app"
            ldt_dockerContainerPublish="-p $ldt_dockerContainerPort:4200"

            if [ "$ldt_task" = "start" ]; then
                ldt_dockerw_doDockerRun "sh -c \"npm run start-local\""
            fi
            if [ "$ldt_task" = "exec" ]; then
                ldt_dockerw_doDockerRun "sh"
            fi
        fi
        if [ "$ldt_sandbox" = "node" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=node:latest
            fi
            if [ "$ldt_dockerContainerPort" = "" ]; then
                ldt_dockerContainerPort=3000
            fi
            ldt_logDebug "configure... 'node' sandbox"
            ldt_dockerContainerName="--name nodejs"
            ldt_dockerContainerUser="-u $(id -u $ldt_me):$(id -g $ldt_me)"
            ldt_dockerContainerVolumes="-v $ldt_workindDir:/usr/src/app"
            ldt_dockerContainerWorkdir="-w /usr/src/app"
            ldt_dockerContainerPublish="-p $ldt_dockerContainerPort:3000"

            if [ "$ldt_task" = "start" ]; then
                ldt_dockerw_doDockerRun "sh -c \"npm run start-local\""
            fi
            if [ "$ldt_task" = "exec" ]; then
                ldt_dockerw_doDockerRun "sh"
            fi
        fi
        if [ "$ldt_sandbox" = "pgadmin" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=dpage/pgadmin4:latest
            fi
            if [ "$ldt_dockerContainerPort" = "" ]; then
                ldt_dockerContainerPort=5050
            fi
            ldt_logDebug "configure... 'pgadmin' sandbox"
            ldt_dockerContainerName="--name pgAdmin"
            ldt_dockerContainerNetwork="--network postgres-net"
            ldt_dockerContainerEnv="-e PGADMIN_DEFAULT_EMAIL=$PGADMIN_USER -e PGADMIN_DEFAULT_PASSWORD=$PGADMIN_PASS"
            ldt_dockerContainerVolumes="-v pgadmin_data:/var/lib/pgadmin"
            ldt_dockerContainerPublish="-p $ldt_dockerContainerPort:80"

            if [ "$ldt_task" = "start" ]; then
                ldt_dockerw_doDockerNetworkCheck postgres-net
                ldt_dockerw_doDockerVolumeCheck pgadmin_data
                ldt_dockerw_doDockerRun
            fi
        fi
        if [ "$ldt_sandbox" = "php" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=php:latest
            fi
            if [ "$ldt_dockerContainerPort" = "" ]; then
                ldt_dockerContainerPort=8080
            fi
            ldt_logDebug "configure... 'php' sandbox"
            ldt_dockerContainerName="--name php"
            ldt_dockerContainerPublish="-p $ldt_dockerContainerPort:80"

            if [ "$ldt_task" = "run" ]; then
                ldt_dockerw_doDockerRun "sh"
            fi
        fi
        if [ "$ldt_sandbox" = "php-fpm" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=php-fpm:latest
            fi
            if [ "$ldt_dockerContainerPort" = "" ]; then
                ldt_dockerContainerPort=3300
            fi
            ldt_logDebug "configure... 'php-fpm' sandbox"
            ldt_dockerContainerName="--name php-fpm"
            ldt_dockerContainerUser="-u $(id -u $ldt_me):$(id -g $ldt_me)"
            ldt_dockerContainerVolumes="-v $ldt_workindDir/dist/www:/usr/src/app -v $ldt_workindDir/dist/conf/nginx.conf:/etc/nginx/nginx.conf"
            ldt_dockerContainerWorkdir="-w /usr/src/app"
            ldt_dockerContainerPublish="-p $ldt_dockerContainerPort:80"

            if [ "$ldt_task" = "run" ]; then
                ldt_dockerw_doDockerRun "sh -c \"tail -f /dev/null\""

                ldt_dockerContainerName="php-fpm"
                ldt_dockerContainerUser="-u root"
                ldt_dockerw_doDockerExec "sh -c \"service nginx start && service php8.2-fpm start\""
            fi
        fi
        if [ "$ldt_sandbox" = "phpmyadmin" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=phpmyadmin:latest
            fi
            if [ "$ldt_dockerContainerPort" = "" ]; then
                ldt_dockerContainerPort=8080
            fi
            ldt_logDebug "configure... 'phpmyadmin' sandbox"
            ldt_dockerContainerName="--name phpmyadmin"
            ldt_dockerContainerNetwork="--network mysql-net"
            ldt_dockerContainerEnv="-e MYSQL_ROOT_PASSWORD=$MYSQL_PASS -e PMA_HOST=mysql -e UPLOAD_LIMIT=10G"
            ldt_dockerContainerVolumes="-v phpmyadmin_data:/var/lib/phpmyadmin"
            ldt_dockerContainerPublish="-p $ldt_dockerContainerPort:80"

            if [ "$ldt_task" = "start" ]; then
                ldt_dockerw_doDockerNetworkCheck mysql-net
                ldt_dockerw_doDockerVolumeCheck phpmyadmin_data
                ldt_dockerw_doDockerRun
            fi
        fi
        if [ "$ldt_sandbox" = "postgres" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=postgres:latest
            fi
            ldt_logDebug "configure... 'postgres' sandbox"
            ldt_dockerContainerName="--name postgres"
            ldt_dockerContainerNetwork="--network postgres-net"
            ldt_dockerContainerEnv="-e POSTGRES_USER=$POSTGRES_USER -e POSTGRES_PASSWORD=$POSTGRES_PASS -e POSTGRES_DB=postgres"
            ldt_dockerContainerVolumes="-v postgres_data:/var/lib/postgresql/data"
            ldt_dockerContainerPublish="-p 5432:5432"

            if [ "$ldt_task" = "start" ]; then
                ldt_dockerw_doDockerNetworkCheck postgres-net
                ldt_dockerw_doDockerVolumeCheck postgres_data
                ldt_dockerw_doDockerRun
            fi
            if [ "$ldt_task" = "backup" ]; then
                echo "TODO: ldtw docker postgres backup"
            fi
            if [ "$ldt_task" = "restore" ]; then
                echo "TODO: ldtw docker postgres restore"
            fi
        fi
        if [ "$ldt_sandbox" = "rabbitmq" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=rabbitmq:latest
            fi
            ldt_logDebug "configure... 'rabbitmq' sandbox"
            ldt_dockerContainerName="--name rabbitmq"
            ldt_dockerContainerEnv="-e RABBITMQ_DEFAULT_VHOST=rabbitmq -e RABBITMQ_DEFAULT_USER=$RABBITMQ_USER -e RABBITMQ_DEFAULT_PASS=$RABBITMQ_PASS"
            ldt_dockerContainerVolumes="-v rabbitmq_data:/var/lib/rabbitmq"
            ldt_dockerContainerPublish="-p 5672:5672 -p 15672:15672"

            if [ "$ldt_task" = "start" ]; then
                ldt_dockerw_doDockerVolumeCheck rabbitmq_data
                ldt_dockerw_doDockerRun
            fi
        fi
        if [ "$ldt_sandbox" = "mkcert" ]; then
            if [ "$ldt_task" = "install" ]; then
                if [ "$(cat ~/.bashrc | grep linuxbrew)" = "" ]; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    (
                        echo
                        echo "# enable linuxbrew"
                        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
                    ) >>~/.bashrc
                    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                    brew install mkcert
                    mkcert -install
                fi
            fi
            if [ "$ldt_task" = "uninstall" ]; then
                if [ ! "$(cat ~/.bashrc | grep linuxbrew)" = "" ]; then
                    mkcert -uninstall
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
                    if [ -d "/home/linuxbrew" ]; then sudo rm -rf /home/linuxbrew; fi
                    if [ -d "/opt/homebrew" ]; then sudo rm -rf /opt/homebrew; fi
                    echo "NOTIFY: check ~/.bashrc file"
                fi
            fi
        fi
        if [ "$ldt_sandbox" = "vscode" ]; then
            if [ "$ldt_task" = "postinstall" ]; then
                read -p "Are you sure, you want to run the Code-Server PostInstall script? (y|n) " -n 1 -r
                clear
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo "==========================================================================="
                    echo "## Visual Studio Code container PostInstall script - v0.0.1              ##"
                    echo "==========================================================================="

                    echo "[INFO] VSCode-PostInstall: upgrade os..."
                    sudo apt update
                    sudo apt upgrade -y
                    echo "[INFO] VSCode-PostInstall: install os-tools..."
                    sudo apt install -y build-essential net-tools curl htop mc nano

                    if [ "$LDT_VSCODE_GIT" = "true" ]; then
                        echo "[INFO] VSCode-PostInstall: install git..."
                        sudo apt install -y git git-flow
                        echo "[INFO] VSCode-PostInstall: configure git..."
                        git config --global user.name $LDT_VSCODE_USER
                        git config --global user.email $LDT_VSCODE_EMAIL
                        git config --global credential.helper "cache --timeout=-1"
                        git config --global init.defaultBranch master
                    fi
                    if [ "$LDT_VSCODE_DOCKER" = "true" ]; then
                        echo "[INFO] VSCode-PostInstall: install docker..."
                        curl -sL "https://get.docker.com" | /bin/sh
                        echo "[INFO] VSCode-PostInstall: install docker-compose..."
                        sudo apt-get install -y docker-compose
                        echo "[INFO] VSCode-PostInstall: configure docker..."
                        sudo adduser $ldt_me sudo
                        sudo adduser $ldt_me docker

                        if [ "$(cat /config/.bashrc | grep docker:autostart)" = "" ]; then
                            echo "" >>/config/.bashrc
                            echo "# docker:autostart" >>/config/.bashrc
                            echo "if [ ! \"\$(service docker status | grep not)\" = \"\" ]; then" >>/config/.bashrc
                            echo "  sudo service docker start" >>/config/.bashrc
                            echo "fi" >>/config/.bashrc
                        fi
                    fi
                    if [ "$LDT_VSCODE_OPEN_JDK" = "true" ]; then
                        echo "[INFO] VSCode-PostInstall: install openjdk-17-jdk..."
                        sudo apt install -y openjdk-17-jdk
                    fi

                    echo "[INFO] VSCode-PostInstall: check ownerships..."
                    sudo chown -R $ldt_me:$ldt_me /config/
                    sudo chown -R $ldt_me:$ldt_me /works/

                    echo "[INFO] VSCode-PostInstall: clean..."
                    sudo apt autoremove -y

                    echo "[INFO] VSCode-PostInstall: configure code-server..."
                    ln -sf /works/.vscode/keybindings.json /config/data/User/keybindings.json
                    ln -sf /works/.vscode/settings.json /config/data/User/settings.json
                    ln -sf /works/.vscode/ssh.id_rsa /config/.ssh/id_rsa
                    ln -sf /works/.vscode/ssh.id_rsa.pub /config/.ssh/id_rsa.pub

                    echo "[INFO] VSCode-PostInstall: done."
                    if [ "$LDT_VSCODE_GIT" = "true" ]; then make --version; fi
                    if [ "$LDT_VSCODE_GIT" = "true" ]; then git --version; fi
                    if [ "$LDT_VSCODE_DOCKER" = "true" ]; then docker --version; fi
                    if [ "$LDT_VSCODE_DOCKER" = "true" ]; then docker-compose --version; fi
                    if [ "$LDT_VSCODE_OPEN_JDK" = "true" ]; then java --version; fi
                fi
            fi
        fi
        if [ "$ldt_sandbox" = "webpack" ]; then
            if [ "$ldt_dockerContainerImage" = "" ]; then
                ldt_dockerContainerImage=node:latest
            fi
            if [ "$ldt_dockerContainerPort" = "" ]; then
                ldt_dockerContainerPort=3000
            fi
            ldt_logDebug "configure... 'webpack' sandbox"
            ldt_dockerContainerName="--name webpack"
            ldt_dockerContainerUser="-u $(id -u $ldt_me):$(id -g $ldt_me)"
            ldt_dockerContainerVolumes="-v $ldt_workindDir:/usr/src/app"
            ldt_dockerContainerWorkdir="-w /usr/src/app"
            ldt_dockerContainerPublish="-p $ldt_dockerContainerPort:3000"

            if [ "$ldt_task" = "start" ]; then
                ldt_dockerw_doDockerRun "sh -c \"npm run start-local\""
            fi
            if [ "$ldt_task" = "exec" ]; then
                ldt_dockerw_doDockerRun "sh"
            fi
        fi
    fi
}

ldt_log() {
    logLevel=$1
    logMessage=$2

    printf "LDT [$logLevel] %s\n" "$logMessage"
}

ldt_logDebug() {
    if [ "$LDT_DEBUG" = "true" ]; then
        ldt_log "DEBUG" "$1"
    fi
}

ldt_logError() {
    ldt_log "ERROR" "$1"
}

ldt_dockerw_doDockerExec() {
    ldt_logDebug "executing..."
    if [ "$ldt_dockerContainerCommand" = "" ]; then ldt_dockerContainerCommand=$1; fi
    cmd="docker exec"
    cmd="$cmd -it"
    cmd="$cmd $ldt_dockerContainerUser"
    cmd="$cmd $ldt_dockerContainerName"
    cmd="$cmd $ldt_dockerContainerCommand"
}

ldt_dockerw_doDockerRun() {
    ldt_logDebug "running..."
    if [ "$ldt_dockerContainerCommand" = "" ]; then ldt_dockerContainerCommand=$1; fi
    cmd="docker run"
    if [ "$LDT_DOCKER_DAEMON" = "true" ]; then
        cmd="$cmd -d"
    else
        cmd="$cmd -it"
    fi
    cmd="$cmd --rm"
    cmd="$cmd $ldt_dockerContainerName"
    cmd="$cmd $ldt_dockerContainerNetwork"
    cmd="$cmd $ldt_dockerContainerUser"
    cmd="$cmd $ldt_dockerContainerEnv"
    cmd="$cmd $ldt_dockerContainerVolumes"
    cmd="$cmd $ldt_dockerContainerWorkdir"
    cmd="$cmd $ldt_dockerContainerPublish"
    cmd="$cmd $ldt_dockerContainerImage"
    cmd="$cmd $ldt_dockerContainerCommand"
    ldt_logDebug "--> cmd='$cmd'"
    eval "$cmd"
}

ldt_dockerw_doDockerNetworkCheck() {
    networkName=$1
    networkExists=$(docker network ls | grep $networkName)

    if [ "$networkExists" = "" ]; then
        ldt_logDebug "--> create docker network... '$networkName'"
        docker network create $networkName
    fi
}

ldt_dockerw_doDockerVolumeCheck() {
    volumeName=$1
    volumeExists=$(docker volume ls | grep $volumeName)

    if [ "$volumeExists" = "" ]; then
        ldt_logDebug "--> create docker volume... '$volumeName'"
        docker volume create $volumeName
    fi
}

main $*
