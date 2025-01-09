#!/usr/bin/env bash

set -e

./wait-for-mssql-to-come-up.sh

echo "[moodle-db-mssql] Setting up Moodle data"
/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P $MSSQL_SA_PASSWORD -d master -i setup.sql
echo "[moodle-db-mssql] Setup complete."
