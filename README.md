# teo

This is a TEO app (based in redmine) for deployment in Openshift demo.

1.  Download Openshift minishift cdk from: https://developers.redhat.com/products/cdk/download/

2.   \# mv cdk-3.0.beta-minishift-linux-amd64 /bin/minishift

3.  $ minishift setup-cdk

4.  $ minishift start --username <Red_Hat_username>  --password <Red_Hat_password>\n
Starting local OpenShift cluster using 'kvm' hypervisor...
Registering machine using subscription-manager
Provisioning OpenShift via '/home/jmn/.minishift/cache/oc/v3.4.1.2/oc [cluster up --use-existing-config --host-config-dir /var/lib/minishift/openshift.local.config --host-data-dir /var/lib/minishift/hostdata --host-volumes-dir /var/lib/minishift/openshift.local.volumes]'
-- Checking OpenShift client ... OK
-- Checking Docker client ... OK
-- Checking Docker version ... OK
-- Checking for existing OpenShift container ... OK
[...]
-- Server Information ... 
   OpenShift server started.
   The server is accessible via web console at:
       https://192.168.42.110:8443

   You are logged in as:
       User:     developer
       Password: developer

   To login as administrator:
       oc login -u system:admin

5.  Open the GUI
    $ minishift console

6.  Log in with user=admin pass=admin

7.  Create a project called "teo" in the GUI

8.  Change teo project privileges to be able to run containers as root:
     $ oc login -u system:admin
     $ oc adm policy add-scc-to-user anyuid -z default -n teo

9.  Build teo app from GitHub:
      $ oc new-app https://github.com/jmnohales/teo.git --strategy=docker

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
  
  
