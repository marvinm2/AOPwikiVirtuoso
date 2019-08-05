# AOPwikiVirtuoso service in Openshift

This repository contains files to create a Virtuoso docker container with AOP-Wiki data in OpenShift

To set up a Virtuoso SPARQL endpoint in OpenShift, there are three deployments required:
--
1. Virtuoso Deployment configuration
2. PersistentVolumeClaim
3. Loader-job deployment

The deployment relies on a project (namespace) called `aopwiki` and the ability to run containers as root. The project should have an NFS **Persistent Volume** available and a **Service Account** that permits Pods (containers) to run with root privilege. If a persistent volume or service account does not exist contact the cluster administrator so that they can be created.

The system administrator simply needs to add a suitable service account to the project
with the following commands: -

`` oc project aopwiki``

``oc create serviceaccount aopwiki``

``oc adm policy add-scc-to-user anyuid -z aopwiki``

### Virtuoso Deployment configuration
The `Virtuoso-aopwiki.yaml` file uses an existing Docker Image from Dockerhub (openlink/virtuoso-opensource-7) and deploys it with a mounted volume from a PersistentVolumeClaim in OpenShift. 

### PersistentVolumeClaim
The `aopwiki-target-pvc.yaml` file is required to set up a PersistentVolumeClaim, which is mounted to both the Virtuoso service as the Loader-job. 

### Loader-job deployment
Prior to deploying the `aopwikiloader.yaml`, a Dockerfile needs to be created that contains the data to be loaded in the Virtuoso service, by executing the `Dockerfile`. In this configuration, the data is stored as `aopwiki-[date].ttl`. 
The `aopwikiloader.yaml` file is a Job configuration, a one-time running container. This Job pulls a Docker Image from Dockerhub and copies its contents to the PersistentVolumeClaim that it is mounted to by executing the commands in the `docker-entrypoint.sh` file. 

## Example SPARQL queries
In `sparqlqueries.md`, some example queries are stored to answer specific questions to the AOP-Wiki data.

## Renewing the data loaded in the Virtuoso SPARQL endpoint on Openshift
Log into Openshift through the command line. 
Remove the previous loader job by 
``oc delete job --selector template=aopwikiloader``
Activate the new dataloader job by
``oc process -f aopwikiloader.yaml | oc create -f -``

Enter the running Virtuoso pod by ``oc rsh <pod>``, remove the old `.ttl` file and replace it with the new one from the mounted folder `/aopwikidata` by entering ``mv ../../../aopwikidata/aopwiki-20190716.ttl .``.

From this point, enter ``isql`` and configure the Virtuoso SQL according to step 6 of the guidelines for a local Virtuoso Docker image with AOP-Wiki RDF: https://github.com/marvinm2/AOPWikiRDF.
