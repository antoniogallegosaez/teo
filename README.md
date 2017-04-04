# teo

This is a TEO app (based in redmine) for deployment in Openshift demo.

1.  Download Openshift minishift cdk from: https://developers.redhat.com/products/cdk/download/

2.   \# mv cdk-3.0.beta-minishift-linux-amd64 /bin/minishift

3.  $ minishift setup-cdk

4.  $ minishift start --username <Red_Hat_username>  --password <Red_Hat_password> <br />
Starting local OpenShift cluster using 'kvm' hypervisor...<br />
Registering machine using subscription-manager<br />
Provisioning OpenShift via '/home/jmn/.minishift/cache/oc/v3.4.1.2/oc [cluster up --use-existing-config --host-config-dir /var/lib/minishift/openshift.local.config --host-data-dir /var/lib/minishift/hostdata --host-volumes-dir /var/lib/minishift/openshift.local.volumes]'<br />
-- Checking OpenShift client ... OK<br />
-- Checking Docker client ... OK<br />
-- Checking Docker version ... OK<br />
-- Checking for existing OpenShift container ... OK<br />
[...]<br />
-- Server Information ... <br />
   OpenShift server started.<br />
   The server is accessible via web console at:<br />
       https://192.168.42.110:8443<br />
   You are logged in as:<br />
       User:     developer<br />
       Password: developer<br />
   To login as administrator:
       oc login -u system:admin

5.  Open the GUI \
    $ minishift console

6.  Create a project called "teo"
     $ oc login -u admin:admin<br />
     $ oc new-project teo

7.  Build teo image from GitHub:<br />
      $ oc new-build https://github.com/jmnohales/teo.git<br />

8.  Change teo project privileges to be able to run containers as root:<br />
     $ oc login -u system:admin<br />
     $ oc adm policy add-scc-to-user anyuid -z default -n teo<br />



10. To Be Continued...

Variables for external database:
  --env='DB_ADAPTER=postgresql' \
  --env='DB_HOST=192.168.42.228' \
  --env='DB_NAME=redmine_production' \
  --env='DB_USER=redmine' \
  --env='DB_PASS=password' \
  --volume=/srv/docker/redmine/redmine:/home/redmine/data \
  teo:1.0
  
  
  Para Ansible Tower:
  oc new-app https://github.com/hatsari/ansible-tower-rhel7-docker-image.git
  
  
