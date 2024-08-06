# websocket_server.rb
require 'faye/websocket'
require 'eventmachine'
require 'em-websocket'

class LogServer
  def initialize(log_file_path)
    @log_file_path = log_file_path
    @clients = []
    @last_position = 0
    @file = File.open(log_file_path, 'r')
    @file.seek(0, IO::SEEK_END) # Move to end of file
  end

  def start
    EM.run do
      EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
        ws.onopen do
          puts "Client connected"
          @clients << ws
          send_last_lines(ws)
        end

        ws.onmessage do |msg|
          # Handle incoming messages if needed
        end

        ws.onclose do
          puts "Client disconnected"
          @clients.delete(ws)
        end
      end

      EM.add_periodic_timer(1) { check_for_updates }
    end
  end

  private

  def send_last_lines(ws)
    lines = File.readlines(@log_file_path).last(10).join
    ws.send(lines)
  end

  def check_for_updates
    return if @file.nil? || @file.eof?

    new_data = @file.read
    puts "Read new data: #{new_data}"
    return if new_data.empty?

    @clients.each { |client| client.send(new_data) }
    # @clients.each do |client|
    #     client.send("Test message at #{Time.now}")
    # end
  end
end


# Initialize and start the server with a path to the log file
log_server = LogServer.new('/home/lalitmali/Desktop/rails7/websocket_app/logfile.log')
log_server.start
