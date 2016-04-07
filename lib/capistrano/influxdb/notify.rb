module InfluxDB
  class Notify
    def initialize connection_opts
      @influxdb = InfluxDB::Client.new(connection_opts)
    end

    def send series_name, status, ref, application
      data = {
        values: { value: 1 },
        tags: {
          status: status,
          ref: ref,
          application: application
        }
      }

      @influxdb.write_point(series_name, data)
    end
  end
end
