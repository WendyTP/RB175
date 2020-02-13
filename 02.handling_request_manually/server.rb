# creating a simple echo server which outputs the request received

require "socket"

server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  client.puts "HTTP/1.1 200 OK\r\n\r\n" # this is the status line (part of the response of the server) 
  #the \r\n\r\n adds a blank line between status line and response header, which is necessary

  client.puts "Content-Type: text/plain\r\n\r\n" # optional response header 
  #the \r\n\r\n adds a blank line between status line and response header, which is necessary
  
  client.puts request_line  # the server outputs the request received, which constitues the response body
  
  client.close
end
