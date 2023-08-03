require 'yaml'

file = YAML.load_file('./docker-compose.yml')

networks_in_compose = []
services = file['services']

services_info = services.keys.map do |key|
  networks_in_compose += services[key]['networks'].compact.uniq
end

app_network_correct = networks_in_compose.select{ |network| network.strip == 'app_net' }.count == 4
user_network_correct = networks_in_compose.select{ |network| network.strip == 'user_net' }.count == 2
route_network_correct = networks_in_compose.select{ |network| network.strip == 'route_net' }.count == 2
post_network_correct = networks_in_compose.select{ |network| network.strip == 'post_net' }.count == 2
offer_network_correct = networks_in_compose.select{ |network| network.strip == 'offer_net' }.count == 2

if !app_network_correct
  raise 'App network not correct'
elsif !user_network_correct
  raise 'User network not correct'
elsif !route_network_correct
  raise 'Route network not correct'
elsif !post_network_correct
  raise 'Post network not correct'
elsif !offer_network_correct
  raise 'Offer network not correct'
else
  puts 'OK'
end
