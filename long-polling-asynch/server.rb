require 'sinatra'
require 'sinatra/async'
require 'json' 

set :server, 'thin' 

Sinatra.register Sinatra::Async

get '/' do
  erb :index
end 
   
aget '/read' do  
  content_type :json 
  
  filename = 'data.txt'
  
  # ... client (might) pass the last time they received an update 
	last = params[:timestamp] == 'null' ? 0 : params[:timestamp].to_i
	current = last_modification(filename)  
	last = last || current
  
  # ... and we're blocking until the file changes 
  EM.defer do   
    check_file_changes = proc do
      if File.zero?(filename) || (current <= last)
        puts "Not Changed!!!! File.zero?(filename) ==> #{File.zero?(filename)}, current: #{current}, last: #{last}"
        current = last_modification(filename) 
        EM.next_tick(&check_file_changes)
      else   
        puts "Streaming... File.zero?(filename) ==> #{File.zero?(filename)}, current: #{current}, last: #{last}"
        body({ :messages => File.read(filename), :timestamp => current }.to_json)
      end
    end 
    EM.next_tick(&check_file_changes)
  end
end   

def last_modification(filename)
  File.mtime(filename).to_time.to_i
end
                                               