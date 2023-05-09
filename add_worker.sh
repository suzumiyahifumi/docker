#!/bin/bash

while getopts m:w: flag
do
    case "${flag}" in
        m) master=${OPTARG};;
        w) worker=${OPTARG};;
    esac
done

docker exec -it $worker /bin/bash -c "apt update && apt install -y postgis && apt install -y postgresql-15-postgis-scripts"

docker exec -it $master /bin/bash -c "psql -U postgres -d postgres -c\"select * from master_add_node('$worker',5432)\""

docker exec -it $master /bin/bash -c "psql -U postgres -d postgres -c\"SELECT master_get_active_worker_nodes();\""