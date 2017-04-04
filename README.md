# teo

This is a TEO app (based in redmine) for deployment in Openshift demo.

1.  Download Openshift minishift cdk from: https://developers.redhat.com/products/cdk/download/

2.   <b>&#35; mv cdk-3.0.beta-minishift-linux-amd64 /bin/minishift</b>

3.  <b>$ minishift setup-cdk</b>\
    Copying minishift-rhel7.iso to '/home/jmn/.minishift/cache/iso/minishift-rhel7.iso'\
    Copying oc to '/home/jmn/.minishift/cache/oc/v3.4.1.2/oc'\
    Creating configuration file '/home/jmn/.minishift/config/config.json'\
    Creating marker file '/home/jmn/.minishift/cdk'\
    CDK 3 setup complete.


4.  <b>$ minishift start --username <Red_Hat_username>  --password <Red_Hat_password></b> <br />
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

5.  Create a project called "teo"\
<b>$ oc login -u admin:admin</b><br />
<b>$ oc new-project teo</b>

6.  Build teo image from GitHub:<br />
<b> $ oc new-build https://github.com/jmnohales/teo.git</b><br />

7.  Change teo project privileges to be able to run containers as root:<br />
<b>$ oc login -u system:admin</b><br />
<b>$ oc adm policy add-scc-to-user anyuid -z default -n teo</b><br />

[.... Wait until image "teo" be ready at the registry ...]

<blockquote>
****     ANSIBLE ZONE   *****  
8. Prepare posgreSQL database with ansible (needs an ansible environment with an inventary called "bbdd"):<br/>
<b>$ wget https://raw.githubusercontent.com/jmnohales/teo/master/postgresql_playbook.yml</b><br/>
<b>$ ansible-playbook postgresql_playbook.yml</b><br/>
**** END OF ANSIBLE ZONE ****<br/>
</blockquote>

9.  Open the GUI \
<b>$ minishift console</b>

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
          DB_PASS=password
          
          
