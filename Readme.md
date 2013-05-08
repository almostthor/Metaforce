Metaforce
=========

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

### Part 1

<!-- copy and paste. Modify height and width if desired. -->
 <object id="scPlayer"  width="779" height="600" type="application/x-shockwave-flash" data="http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/4443861b-d0b3-43af-aacf-7368f00ecb16/jingswfplayer.swf" >
 <param name="movie" value="http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/4443861b-d0b3-43af-aacf-7368f00ecb16/jingswfplayer.swf" />
 <param name="quality" value="high" />
 <param name="bgcolor" value="#FFFFFF" />
 <param name="flashVars" value="thumb=http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/4443861b-d0b3-43af-aacf-7368f00ecb16/FirstFrame.jpg&containerwidth=1024&containerheight=789&content=http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/4443861b-d0b3-43af-aacf-7368f00ecb16/00000008.swf&blurover=false" />
 <param name="allowFullScreen" value="true" />
 <param name="scale" value="showall" />
 <param name="allowScriptAccess" value="always" />
 <param name="base" value="http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/4443861b-d0b3-43af-aacf-7368f00ecb16/" />
 Unable to display content. Adobe Flash is required.
</object>

### Part 2

<!-- copy and paste. Modify height and width if desired. -->
 <object id="scPlayer"  width="779" height="598" type="application/x-shockwave-flash" data="http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/a1c99297-956b-44a5-b588-14c8598f1635/jingswfplayer.swf" >
 <param name="movie" value="http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/a1c99297-956b-44a5-b588-14c8598f1635/jingswfplayer.swf" />
 <param name="quality" value="high" />
 <param name="bgcolor" value="#FFFFFF" />
 <param name="flashVars" value="thumb=http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/a1c99297-956b-44a5-b588-14c8598f1635/FirstFrame.jpg&containerwidth=1024&containerheight=787&content=http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/a1c99297-956b-44a5-b588-14c8598f1635/00000009.swf&blurover=false" />
 <param name="allowFullScreen" value="true" />
 <param name="scale" value="showall" />
 <param name="allowScriptAccess" value="always" />
 <param name="base" value="http://content.screencast.com/users/pnelson_reside.biz/folders/Jing/media/a1c99297-956b-44a5-b588-14c8598f1635/" />
 Unable to display content. Adobe Flash is required.
</object>
