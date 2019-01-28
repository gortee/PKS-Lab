#!/bin/bash

#Check if script has already ran
file="~/nsx-t-ci-pipeline/.cc-p1.ran"
if [ ! -f "$file" ]
then
#First run. Leave ran marker
touch ~/nsx-t-ci-pipeline/.cc-p1.ran
#Add some aliases to make common tasks easier
alias pksli='pks login -a pks.corp.local -u pksadmin -p VMware1! --skip-ssl-validation'
alias pksgc='pks get-credentials my-cluster'
echo "alias pksli='pks login -a pks.corp.local -u pksadmin -p VMware1! --skip-ssl-validation'" >> ~/.bashrc
echo "alias pksgc='pks get-credentials my-cluster'" >> ~/.bashrc
else
#Script has previously ran, reset config file to original state before running again
mv ~/nsx-t-ci-pipeline/pipelines/pks-params.yml.bak ~/nsx-t-ci-pipeline/pipelines/pks-params.yml
mv ~/nsx-t-ci-pipeline/tasks/config-pks/task.sh.bak ~/nsx-t-ci-pipeline/tasks/config-pks/task.sh
mv ~/nsx-t-ci-pipeline/tasks/config-pks/config-pks-1.1.sh.bak ~/nsx-t-ci-pipeline/tasks/config-pks/config-pks-1.1.sh
mv ~/nsx-t-ci-pipeline/tasks/config-pks/task.yml.bak ~/nsx-t-ci-pipeline/tasks/config-pks/task.yml
mv ~/nsx-t-ci-pipeline/pipelines/install-pks-pipeline.yml.bak ~/nsx-t-ci-pipeline/pipelines/install-pks-pipeline.yml
mv ~/etc/nsswitch.conf.bak ~/etc/nsswitch.con
fi

#Define Ops Manager and PKS releases to install - OpsMan 2.3.0 / PKS 1.2.0
sed -i.bak '/opsman\_major\_minor\_version: \^2\\.3.*$/c\opsman_major_minor_version: ^2\\.3\\.0$'  ~/nsx-t-ci-pipeline/pipelines/pks-params.yml
sed -i '/pks\_major\_minor\_version: \^1\\.2.*$/c\pks_major_minor_version: ^1\\.2\\.0$'  ~/nsx-t-ci-pipeline/pipelines/pks-params.yml

#Comment out property references in pks pipeline
sed -i.bak '/pks_syslog_properties/,/Finished configuring syslog properties/s/^/#/' ~/nsx-t-ci-pipeline/tasks/config-pks/task.sh
sed -i.bak '/PKS_VRLI_ENABLED/,/\<fi\>/s/^/#/' ~/nsx-t-ci-pipeline/tasks/config-pks/config-pks-1.1.sh
sed -i.bak '/PKS_SYSLOG/s/^/#/' ~/nsx-t-ci-pipeline/tasks/config-pks/task.yml
sed -i.bak '/PKS_SYSLOG/s/^/#/' ~/nsx-t-ci-pipeline/pipelines/install-pks-pipeline.yml
sed -i '/pks_tile_syslog/s/^/#/' ~/nsx-t-ci-pipeline/pipelines/pks-params.yml

#Fix configure-pks pipeline that causes k8s clusters to be created in mgmta01
sed -i 's/pks_tile_vcenter_cluster_list: RegionA01-MGMT01,RegionA01-COMP01/pks_tile_vcenter_cluster_list: RegionA01-COMP01/' ~/nsx-t-ci-pipeline/pipelines/pks-params.yml

#Correct name service switch config for cli-vm dns name resolution
sed -i.bak  '/mdns4/c\hosts:  files  dns' /etc/nsswitch.conf

#Unused block - Placeholder for anything that may require vSphere config changes
#curl -k -i -u administrator@vsphere.local:VMware1! -X POST -c cookie-jar.txt https://vcsa-01a.corp.local/rest/com/vmware/cis/session
#curl -k -i -b cookie-jar.txt https://vcsa-01a.corp.local/rest/vcenter/...

#Switch to home directory post-script
echo "=========================================="
echo "    Patched PKS Ninja v10 Template"
echo "=========================================="
cd ~
