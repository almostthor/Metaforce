Metaforce
=========

[![Build Status](http://ec2-54-244-204-234.us-west-2.compute.amazonaws.com/job/Metaforce/badge/icon)](http://ec2-54-244-204-234.us-west-2.compute.amazonaws.com/job/Metaforce/)

This tool allows you to track and manage the propogation of manual Force.com metadata changes to the stack of development environments.

 * Create and manage active environments
 * Create change records per environment
 * Create, manage and deploy manifests to track replication of changes between environments
 * Link changes to a Jira project
 * Automatically clone deployed manifests to subordinate dev environments
 * Nightly report to all dev environments of all open manifests
 * Dashboard showing manual change metrics

<img src="https://dl.dropboxusercontent.com/u/1227854/Shared%20Files/metaforce-changes.png"/>

Install
-------

 * Clone the repo locally
 * Deploy to the target production environment via Force.com IDE

Configuration
-------------

### Clone Deployed Manifests

The system provides the ability to clone manifests that are deployed to the integration environment to all developer sandboxes. The purpose of this feature is to ensure that all development enviroments are kept up-to-date with changes made higher in the development stack.

To enable this feature:

 * Setup > App Setup > Create > Custom Labels > Metaforce_Clone_Deployed
 	* set to 'true'
 * Setup > App Setup > Create > Custom Labels > Metaforce_Integration_Environment
 	* enter the name of your Integration environment

Setup
-----

 * Enter environment records and assign ownership of the records accordingly
 	* Mark the enviroments as In Use
 	* Enter the sandbox's Salesforce.com Organization ID (from Setup > Administration Setup > Company Profile > Update your company information)

Workflow
--------

The typical workflow for using Metaforce after setup typically looks like the following:

1. Logs one or more changes against their dev environment
2. Create a manifest record to send changes to another environment - usually higher in the stack
3. Add the changes from step one to the manifest
4. Release the manifest to the destination envionment - owner of the destination is notified via email
5. Replicate the changes in the desitination environment and mark each as deployed
6. When all changes in the manifest are deployed the manifest is automatically marked deployed
7. If the Clone Deployed Manifests feature is enabled and the destination environment is the defined integration environment, the system will create a clone of the deployed manifest for each active developer environment.

Demo
----

 * http://www.youtube.com/watch?v=X_yqusfyYBo