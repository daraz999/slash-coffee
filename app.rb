require 'sinatra'
require 'sinatra/activerecord'
require 'net/http'
require './config/i18n'
require './config/environments'
require './app/commands'

post '/food' do
  content_type :json

  if params['token'] == ENV['SLACK_VERIFICATION_TOKEN']
    team_id = params['team_id']
    team_name = params['team_domain']
    channel_id = params['channel_id']
    channel_name = params['channel_name']
    user_id = params['user_id']
    user_name = params['user_name']
    text = params['text']
    Commands.execute(team_id, team_name, channel_id, channel_name, user_id, user_name, text).to_json
  else
    {text: "Nope"}.to_json
  end
end

get '/authed' do
  uri = URI('https://slack.com/api/oauth.access')
  uri_params = {client_id: ENV['SLACK_CLIENT_ID'], client_secret: ENV['SLACK_CLIENT_SECRET'], code: params['code']}
  uri.query = URI.encode_www_form(uri_params)
  Net::HTTP.get_response(uri)

  redirect 'http://food.agelber.com/authed/'
end
