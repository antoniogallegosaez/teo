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

[.... Wait until image teo be ready at the registry ...]

  
9. Prepare posgreSQL database with ansible (needs an ansible environment with an inventary called "bbdd"):
     $ wget https://raw.githubusercontent.com/jmnohales/teo/master/postgresql_playbook.yml
     $ ansible-playbook postgresql_playbook.yml

10. Launch a teo instance from the GUI:
      - Select Project "teo"
      - Select "Add to project in the middle of the menu bar"
      - Select Tab "Deploy Image"
      - Image Stream Tag:
          teo / teo / latest
      - Set the following variables:
          DB_ADAPTER=postgresql \
          DB_HOST=<posgreSQL_server_IP> \
          DB_NAME=redmine_production \
          DB_USER=redmine \
          DB_PASS=password \
          
          

  
