FROM mcr.microsoft.com/mssql/server:2022-latest

# Starting with SQL*Server 2017-CU6, by default, flushing became
# more aggresive, in order to guarantee consistency under power
# failures and similar situations. Explanations available:
#   https://bobsql.com/sql-server-on-linux-forced-unit-access-fua-internals/
# But it came with some severe performance problems on write operations
# that haven't been fixed yet (making it some env variable for the images
# or whatever). See https://github.com/microsoft/mssql-docker/issues/355 .
#
# The very same applies to SQL*Server 2019.
#
# So here, we are just disabling such an aggressive flushing to make it
# work like was before CU6. We don't need it for testing purposes and
# differences, tested under standard conditions are big enough:
# Complete phpunit runs:
# - 2019-CU18: 4h 38m
# - 2019-CU18 + this patch: 1h 33m
USER root
RUN /opt/mssql/bin/mssql-conf traceflag 3979 on && \
        /opt/mssql/bin/mssql-conf set control.alternatewritethrough 0 && \
        /opt/mssql/bin/mssql-conf set control.writethrough 0

ADD root/ /

EXPOSE 1433

USER mssql
CMD ["/docker-entrypoint.sh"]
