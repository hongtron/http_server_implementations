require "socket"

server = TCPServer.new("127.0.0.1", 3000)

loop do
  Thread.start(server.accept) do |client|
    contents = client.recv(2048)
    puts contents
    client.close
  end
end
