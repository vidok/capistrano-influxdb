require 'influxdb'
require 'influxdb/notify'

namespace :influxdb do
  notify = InfluxDB::Notify.new fetch(:influxdb_connection, {})
  options = fetch(:influxdb_variables, [
      :application,
      :branch,
      :stage,
  ]).inject({}) do |hash, key|
    hash[key] = fetch(key, nil); hash
  end

  series_name = fetch(:influxdb_series, 'deploys')

  info "Reporting deploy to influxdb"

  desc 'Send deploy success event to influxdb'
  task :success_report do
    on :local do
      notify.send(series_name, options.merge(status: 'success'))
    end
  end

  desc 'Send deploy rollback event to influxdb'
  task :rollback_report do
    on :local do
      notify.send(series_name, options.merge(status: 'rollback'))
    end
  end

end

after 'deploy:finished', 'influxdb:success_report'
after 'deploy:finishing_rollback', 'influxdb:rollback_report'
