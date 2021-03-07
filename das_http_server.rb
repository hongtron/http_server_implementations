#!/usr/bin/env ruby

# following along with:
# https://www.destroyallsoftware.com/screencasts/catalog/http-server-from-scratch

require 'socket'

def main
  socket = Socket.new(
    :INET, # internet socket (as opposed to unix)
    :STREAM, # TCP
  )
  socket.setsockopt(
    Socket::SOL_SOCKET, # socket-level option (as opposed to TCP)
    Socket::SO_REUSEADDR, # restart our server without kernel complaining socket is in use
    true, # killing/restarting server will be easier now
  )

  socket.bind(Addrinfo.tcp("127.0.0.1", 9000))
  socket.listen(
    0 # number of connections that can be queued behind the current
  )

  conn_sock, addr_info = socket.accept
  conn = Connection.new(conn_sock)

  request = read_request(conn)
  respond_for_request(conn_sock, request)
end

class Connection
  def initialize(conn_sock)
    @conn_sock = conn_sock
    @buffer = ""
  end

  def read_line
    read_until("\r\n")
  end

  def read_until(string)
    until @buffer.include?(string)
      @buffer += @conn_sock.recv(7) # max number of bytes to accept
    end

    result, @buffer = @buffer.split(string, 2) # read up to the newline, but don't return it
    result
  end
end

def read_request(conn)
  request_line = conn.read_line
  method, path, version = request_line.split(" ", 3)
  headers = {}
  loop do
    line = conn.read_line
    break if line.empty?
    key, value = line.split(/:\s*/, 2)
    headers[key] = value
  end
  Request.new(method, path, headers)
end

def respond(conn_sock, status_code, content)
  status_text = {
    200 => "OK",
    404 => "Not Found",
  }.fetch(status_code)

  conn_sock.send(
    "HTTP/1.1 #{status_code} #{status_text}\r\n",
    0, # options (0 is none)
  )
  conn_sock.send("Content-Length: #{content.length}\r\n", 0)
  conn_sock.send("\r\n", 0)
  conn_sock.send(content, 0)
end

def respond_for_request(conn_sock, request)
  path = Dir.getwd + request.path # insecure... path can contain '..'
  if File.exists?(path)
    if File.executable?(path)
      content = `#{path}`
    else
      content = File.read(path)
    end
    status_code = 200
  else
    content = ""
    status_code = 404
  end

  respond(conn_sock, status_code, content)
end

Request = Struct.new(:method, :path, :headers)

main
