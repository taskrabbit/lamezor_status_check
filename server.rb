require 'sinatra'
require 'octokit'
require 'json'

ACCESS_TOKEN = ENV['GITHUB_ACCESS_TOKEN']

before do
  @client ||= Octokit::Client.new(:access_token => ACCESS_TOKEN)
end

get '/' do
  "<h1>Lamezor Status Check</h1><p>A thing for github protected repos</p>"
end

post '/event_handler' do
  @payload = JSON.parse(params[:payload])

  case request.env['HTTP_X_GITHUB_EVENT']
  when "pull_request"
    if @payload["action"] == "opened"
      process_pull_request(@payload["pull_request"])
    end
  else
    "I don't know what to do here..."
  end
end

helpers do
  def process_pull_request(pull_request)
    puts "Processing pull request: #{pull_request['title']}"
    @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'pending')

    sleep 10

    @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'success')
    puts "Pull request processed: #{pull_request['title']}"
  end
end