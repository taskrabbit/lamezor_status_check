require 'sinatra'
require 'octokit'
require 'json'

ACCESS_TOKEN = ENV['GITHUB_ACCESS_TOKEN']

before do
  @client ||= Octokit::Client.new(:access_token => ACCESS_TOKEN)
end

get '/' do
  response = ""
  response = response + "<h1>Lamezor Status Check</h1>"
  response = response + "<p>A thing for github protected repos</p>"
  response = response + "<p>Learn more @ <a href=\"https://github.com/taskrabbit/lamezor_status_check\">https://github.com/taskrabbit/lamezor_status_check</a></p>"
end

post '/pull_request_event' do
  @payload = JSON.parse(params[:payload])

  if(@payload["pull_request"].nil?)
    status 400
    "This is not a pull request"
  end

  process_pull_request(@payload["pull_request"])
  "processed!"
end

helpers do
  def process_pull_request(pull_request)
    puts pull_request
    puts pull_request['base']
    puts pull_request['base']['repo']
    puts pull_request['base']['repo']['full_name']
    
    repo_name = pull_request['base']['repo']['full_name']
    commit_title = pull_request['title']
    sha = pull_request['head']['sha']

    puts "Processing pull request: #{repo_name} | #{commit_title}"
    @client.create_status(repo_name, sha, 'pending')

    sleep 10

    @client.create_status(repo_name, sha, 'success')
    puts "Pull request processed: #{repo_name} | #{commit_title}"
  end
end
