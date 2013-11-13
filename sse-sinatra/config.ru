Dir.chdir File.dirname(__FILE__)

require "bundler/setup"
require "rack"

require "sinatra/base"
require "sinatra/sse"

class TimeServer < Sinatra::Base
  include Sinatra::SSE
  
  get '/' do
    erb :index
  end
      
  get '/ticktock' do
    sse_stream do |out|
      EM.add_periodic_timer(1) do 
        right_now = Time.now.to_s
        puts "Sending #{right_now}"
        out.push :event => "timer", :data => right_now
      end
    end
  end
end

use Rack::CommonLogger
run TimeServer.new