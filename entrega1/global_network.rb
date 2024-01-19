require 'yaml'

file = YAML.load_file('./docker-compose.yml')

networks_in_compose = []
services = file['services']

services_info = services.keys.map do |key|
  networks_in_compose += services[key]['networks'].compact.uniq
end

app_network_correct = networks_in_compose.select{ |network| network.strip == 'app_net' }.count == 4

if !app_network_correct
  raise 'App network not correct'
else
  puts 'OK'
end
