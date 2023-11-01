require_relative './Network'
require_relative './Server'

class ConsoleApp
  def initialize
    @network = Network.new
  end

  def create_servers
    print "Enter the number of servers: "
    num_servers = gets.chomp.to_i

    num_servers.times do |i|
      server_name = "Server #{i + 1}"
      bandwidth = rand(1..10) # Throughput 1 to 10
      server = Server.new(server_name, bandwidth)
      @network.add_server(server)
    end
  end

  def create_random_connections
    @network.servers.each do |server_name, server|
      num_connections = rand(1..@network.servers.length - 1) # Random number of links from 1 to (number of servers - 1)
      available_servers = @network.servers.keys - [server_name]
      num_connections.times do
        random_server_name = available_servers.sample
        bandwidth = rand(1..10)
        server.add_connection(@network.servers[random_server_name], bandwidth)
        available_servers -= [random_server_name]
      end
    end
  end

  def display_graph
    puts "A graph of servers and links:"
    @network.servers.each do |server_name, server|
      connections = server.connections.map { |neighbor, bandwidth| "#{neighbor.name} (#{bandwidth})" }.join(", ")
      puts "#{server_name} -> #{connections}"
    end
  end

  def find_optimal_path
    print "Enter the source (e.g., 'Server 1'): "
    source = gets.chomp
    print "Enter a destination (e.g. 'Server 2'): "
    destination = gets.chomp
    print "Enter the size of the data to be transferred (in MB): "
    data_size = gets.chomp.to_f # Size of transferred data in MB

    # Set the size of transmitted data for all servers
    @network.servers.each do |_, server|
      server.data_size = data_size
    end

    optimal_path = @network.dijkstra(source, destination)
    puts "The optimal path from #{source} to #{destination}: #{optimal_path.join(' -> ')}"
  end

  def run
    create_servers
    create_random_connections
    display_graph
    find_optimal_path
  end
end