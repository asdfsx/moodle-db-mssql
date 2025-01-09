#!/usr/bin/env bash

set -e

i=0
until /opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -d master -l 1 -Q "SELECT 1" > /dev/null 2>&1
do
    echo "[moodle-db-mssql] Waiting for SQL to accept connections"
    sleep 10

    i=$((i+1))
    if [ $i -gt ${MSSQL_WAIT4READY:-60} ]; then
        echo "[moodle-db-mssql] timed out waiting for server to accept connections"
        exit 1;
    fi
done

echo "[moodle-db-mssql] SQL Server UP"
