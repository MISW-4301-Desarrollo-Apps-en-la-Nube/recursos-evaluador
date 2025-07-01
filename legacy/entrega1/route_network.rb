require 'yaml'

file = YAML.load_file('./docker-compose.yml')

networks_in_compose = []
services = file['services']

services_info = services.keys.map do |key|
  networks_in_compose += services[key]['networks'].compact.uniq
end

route_network_correct = networks_in_compose.select{ |network| network.strip == 'route_net' }.count == 2

if !route_network_correct
  raise 'Route network not correct'
else
  puts 'OK'
end
