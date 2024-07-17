#!/bin/sh

echo "Fetching license files from /opt/shared/licenses folder"

if [ -f "/opt/shared/licenses/is-license.xml" ]; then
    echo "Copying Integration Server license file"
    cp /opt/shared/licenses/is-license.xml /opt/webmethods/IntegrationServer/conf/license.xml
    cp /opt/shared/licenses/is-license.xml /opt/webmethods/IntegrationServer/instances/default/config/licenseKey.xml
else
    echo "Integration Server license not found - place the license in a is-license.xml file"
    echo "Interruption of startup process"
    exit 1
fi

if [ -f "/opt/shared/licenses/at-license.xml" ]; then
    echo "Copying Active Transfer Server license file"
    cp /opt/shared/licenses/at-license.xml /opt/webmethods/IntegrationServer/instances/default/packages/WmMFT/config/licenseKey.xml
    cp /opt/shared/licenses/at-license.xml /opt/webmethods/IntegrationServer/packages/WmMFT/config/licenseKey.xml
else
    echo "Active Transfer Server license not found - place the license in a at-license.xml file"
fi

if [ -f "/opt/shared/licenses/br-license.xml" ]; then
    echo "Copying Business Rules license file"
    cp /opt/shared/licenses/br-license.xml /opt/webmethods/IntegrationServer/instances/default/packages/WmBusinessRules/config/licenseKey.xml
    cp /opt/shared/licenses/br-license.xml /opt/webmethods/IntegrationServer/packages/WmBusinessRules/config/licenseKey.xml
    cp /opt/shared/licenses/br-license.xml /opt/webmethods/common/conf/BusinessRulesLicenseKey.xml
else
    echo "Business Rules license not found - place the license in a br-license.xml file"
fi

if [ -f "/opt/shared/licenses/tn-license.xml" ]; then
    echo "Copying Trading Networks license file"
else
    echo "Trading Networks license not found - place the license in a tn-license.xml file"
fi

if [ -f "/opt/shared/licenses/um-license.xml" ]; then
    echo "Copying Universal Messaging license file"
    cp /opt/shared/licenses/um-license.xml /opt/webmethods/UniversalMessaging/server/umserver/licence.xml
else
    echo "Universal Messaging license not found - place the license in a um-license.xml file"
fi

