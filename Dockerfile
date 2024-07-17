FROM quay.io/staillanibm/webmethods:10.15.20240716 as builder

USER root

# Delete the backups create by the update manager
RUN rm -rf /opt/webmethods/jvm/jvm*.bck
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/config/backup/*
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/packages/WmMFT/resources/backup/*
RUN rm -rf /opt/webmethods/install/fix/backup/*

RUN rm -rf /opt/webmethods/profiles/SPM/workspace/temp/*

# Empty the logs directories
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/XAStore/logs
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/logs
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/packages/WmAdmin/pub/assets/i18n/logs
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/packages/WmMFT/resources/logs
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/packages/WmSAP/logs
RUN rm -rf /opt/webmethods/IntegrationServer/instances/logs
RUN rm -rf /opt/webmethods/IntegrationServer/packages/WmAdmin/pub/assets/i18n/logs
RUN rm -rf /opt/webmethods/IntegrationServer/packages/WmSAP/logs
RUN rm -rf /opt/webmethods/MWS/bin/logs
RUN rm -rf /opt/webmethods/MWS/server/default/logs
RUN rm -rf /opt/webmethods/MWS/tools/docker/logs
RUN rm -rf /opt/webmethods/SAGUpdateManager/UpdateManager/logs
RUN rm -rf /opt/webmethods/SAGUpdateManager/logs
RUN rm -rf /opt/webmethods/SAGUpdateManager/osgi/logs
RUN rm -rf /opt/webmethods/common/runtime/agent/logs
RUN rm -rf /opt/webmethods/install/fix/logs
RUN rm -rf /opt/webmethods/install/logs
RUN rm -rf /opt/webmethods/install/profile/logs
RUN rm -rf /opt/webmethods/profiles/CTP/logs
RUN rm -rf /opt/webmethods/profiles/IS_default/logs
RUN rm -rf /opt/webmethods/profiles/MWS_default/logs
RUN rm -rf /opt/webmethods/profiles/SPM/logs

# Remove the licenses from the images
RUN rm /opt/webmethods/IntegrationServer/conf/license.xml
RUN rm /opt/webmethods/IntegrationServer/instances/default/config/licenseKey.xml
RUN rm /opt/webmethods/IntegrationServer/instances/default/packages/WmBusinessRules/config/licenseKey.xml
RUN rm /opt/webmethods/IntegrationServer/instances/default/packages/WmMFT/config/licenseKey.xml
RUN rm /opt/webmethods/IntegrationServer/packages/WmBusinessRules/config/licenseKey.xml
RUN rm /opt/webmethods/IntegrationServer/packages/WmMFT/config/licenseKey.xml
RUN rm /opt/webmethods/common/DigitalEventServices/license/license.xml
RUN rm /opt/webmethods/common/conf/BusinessRulesLicenseKey.xml
RUN rm /opt/webmethods/UniversalMessaging/server/umserver/licence.xml

RUN find /opt/webmethods -type f -name '.lock' -exec rm {} \;

RUN chgrp -R root /opt/webmethods && chmod -R g=u /opt/webmethods


FROM registry.access.redhat.com/ubi9/ubi:latest

ENV JAVA_HOME=/opt/webmethods/jvm/jvm/ \
    JRE_HOME=/opt/webmethods/jvm/jvm/ \
    JDK_HOME=/opt/webmethods/jvm/jvm/

RUN yum -y update ;\
    yum -y install \
        procps \
        shadow-utils \
        findutils \
        nmap-ncat \
        ;\
    yum clean all ;\
    rm -rf /var/cache/yum ;\
    useradd -u 1724 -m -g 0 -d /opt/webmethods wm

RUN chmod 770 /opt/webmethods
COPY --from=builder /opt/webmethods /opt/webmethods
ADD --chown=wm:root startup.sh /opt/webmethods/startup.sh
ADD --chown=wm:root shutdown.sh /opt/webmethods/shutdown.sh
ADD --chown=wm:root entrypoint.sh /opt/webmethods/entrypoint.sh
ADD --chown=wm:root licenses.sh /opt/webmethods/licenses.sh
RUN chmod 774 /opt/webmethods/startup.sh /opt/webmethods/shutdown.sh /opt/webmethods/entrypoint.sh /opt/webmethods/licenses.sh

USER wm

EXPOSE 5555
EXPOSE 9999
EXPOSE 5553

ENTRYPOINT "/bin/bash" "-c" "/opt/webmethods/entrypoint.sh"