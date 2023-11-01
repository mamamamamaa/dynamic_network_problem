class Server
  attr_accessor :name, :bandwidth, :connections, :data_size

  def initialize(name, bandwidth)
    @name = name
    @bandwidth = bandwidth
    @connections = {}
    @data_size = 0 # The size of the data to be transmitted
  end

  def add_connection(server, bandwidth)
    @connections[server] = bandwidth
  end
end