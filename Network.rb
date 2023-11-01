class Network
  attr_accessor :servers

  def initialize
    @servers = {} # Stores servers on the network
  end

  def add_server(server)
    @servers[server.name] = server
  end

  def dijkstra(source, destination)
    distances = {} # Stores the distance from the source to each server
    previous_servers = {} # Stores previous servers on the path to each server
    unvisited_servers = @servers.keys # Start counting all servers unvisited

    @servers.each do |server_name, server|
      distances[server_name] = Float::INFINITY
    end
    distances[source] = 0

    while !unvisited_servers.empty?
      current_server = unvisited_servers.min_by { |server| distances[server] }
      break if distances[current_server] == Float::INFINITY
      unvisited_servers.delete(current_server)

      @servers[current_server].connections.each do |neighbor, bandwidth|
        alt = distances[current_server] + bandwidth
        if alt < distances[neighbor.name]
          distances[neighbor.name] = alt
          previous_servers[neighbor.name] = current_server
        end
      end
    end

    # Construct an optimal path from source to destination
    path = []
    current_server = destination
    while previous_servers[current_server]
      path.unshift(current_server)
      current_server = previous_servers[current_server]
    end
    path.unshift(source)

    path
  end
end