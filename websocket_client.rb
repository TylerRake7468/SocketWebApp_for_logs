# websocket_client.rb
require 'faye/websocket'
require 'eventmachine'

class LogClient
  def initialize(url)
    @url = url
  end

  def start
    EM.run do
      ws = Faye::WebSocket::Client.new(@url)

      ws.on :open do |event|
        puts "Connected to server"
      end

      ws.on :message do |event|
        puts "New log entry: #{event.data}"
      end

      ws.on :close do |event|
        puts "Disconnected from server"
        EM.stop
      end
    end
  end
end

# Initialize and start the client with the WebSocket URL
log_client = LogClient.new('ws://localhost:8080/')
log_client.start
