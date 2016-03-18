# Lamezor Status Check

It is awesome that Github lets you edit files via the web interface.  This will make it possible for less technical folks to modify code/copy.  Hooray!

That said, we want to protect our integration/production branches from folks editing things all willy-nilly.  You can use [protected branches](https://developer.github.com/changes/2015-09-03-ensure-your-app-is-ready-for-protected-branches/) to make sure that a certain branch is safe, but you need a "Status Check" to lock the branch against.  This tool is a simple no-op status check that always says the branch is OK after a few seconds... but that's enough to lock down a branch from being edited online!

## Install
`bundle install`
`sinatra server.rb`

## Deployment
This app is running on Heroku at the URL `lamezor-status-check.taskrabbit.net`.  The Heroku app is connected to the github project and will auto-deploy itself!
