require 'sinatra'
require 'json' 

get '/' do
  erb :index
end 
   
get '/read' do  
  content_type :json 
  
  filename = 'data.txt'
  
  # ... client (might) pass the last time they received an update 
	last = params[:timestamp] == 'null' ? 0 : params[:timestamp].to_i
	current = last_modification(filename)  
  
  # ... and we're blocking until the file changes 
  not_changed_or_emtpy = true
	while (not_changed_or_emtpy) do
		sleep 0.1 
		not_changed_or_emtpy = File.zero?(filename) || (current <= last)
		current = last_modification(filename)
	end 

	{ :messages => File.read(filename), :timestamp => current }.to_json
end 

def last_modification(filename)
  File.mtime(filename).to_time.to_i
end
                                               