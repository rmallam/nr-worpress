FROM docker.io/bitnami/wordpress:5.8.1-debian-10-r2
USER root
ADD newrelic.tar.gz /tmp
RUN export NR_INSTALL_USE_CP_NOT_LN=1 && \
    export NR_INSTALL_SILENT=1 && \
    /tmp/newrelic-php5-*/newrelic-install install && \
    rm -rf /tmp/newrelic-php5-* /tmp/nrinstall* && \
    sed -i \
      -e 's/"REPLACE_WITH_REAL_KEY"/"LICENCEHERE"/' \
      -e 's/newrelic.appname = "PHP Application"/newrelic.appname = "wordpress"/' \
      -e 's/;newrelic.daemon.app_connect_timeout =.*/newrelic.daemon.app_connect_timeout=15s/' \
      -e 's/;newrelic.daemon.start_timeout =.*/newrelic.daemon.start_timeout=5s/' \
      /opt/bitnami/php/etc/conf.d/newrelic.ini