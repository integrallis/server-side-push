require 'sinatra'  
require 'faye'  

Faye::WebSocket.load_adapter('thin')  
use Faye::RackAdapter, :mount => '/faye', :timeout => 45

get '/' do
  erb :index
end 

get '/room' do         
  erb :room, :locals => { :room => params[:room], :username => params[:username] }
end
   

                                               