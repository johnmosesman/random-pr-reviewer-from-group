# README

The purpose of this repo is to allow for random review requesting based on a team and its members. When a team is tagged for review, this repo will randomly select one person from the team and tag them for review.

Things needed to make this work:

1) A webhook on the repo pointing to this app (`/webhooks/pull_request`)
2) The team you want to tag with Read access to the repo
3) An `ACCESS_TOKEN` ENV with the following scopes: admin on the repo (`public_repo` or `repo`) and `admin:org read:org` (to get team member info)

# Local testing

You can use this repo for local testing and the `test` group to test with. I use [ngrok](https://ngrok.com/) locally to point the webhook to my local.
