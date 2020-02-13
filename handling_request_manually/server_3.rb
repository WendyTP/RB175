# creating a simple server which returns an HTML and valid response to client (browser) 

require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")
  params = params.split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK" # http response status line
  # for browser to interpret an HTML, no need to have an empty line between status line and response header
  client.puts "Content-Type: text/html" # single http response header - content type, indicates to browser to display the HTML sent back
  client.puts  # for borwser to interpret an HTML, it's needed to have an empty line between response header and html
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"  
     # the pre tags indicate to browser to directly display the content to the user, 
     #and preserves white space - output 3 lines of content instead of 3 content on 1 line (sperated by space)
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"
  
  client.puts "<h1>Rolls!</h1>"

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i
  
  rolls.times do
    roll = rand(sides) + 1
    client.puts "<p>", roll, "</p>"
  end

  client.puts "</body>"
  client.puts "</html>"
  
  client.close
end