# Timer for Metacran tasks

We have various updating and checking tasks that we want to
execute the regular time intervals. This is currently done
by a small gear in the Red Hat OpenShift cloud.

## Current tasks:

* Update the CRANDB database from CRAN, one a minute. (We only perform a
  HEAD request and check the Etag to see if there is anything new,
  and don't actually download anything, unless there is something new.)

## These have to be implemented/transfered:

* Update number of reverse dependencies in the ElasticSearch DB, issue #1.
* Update the github repos, this is currently on pave.igraph.org, issue #2.
* Update the CRAN@Github web page, this is currently on pave, issue #3.
* Update the metacran/PACKAGES repo, #4.
* Check that github repos and the DB are in sync, #5.
