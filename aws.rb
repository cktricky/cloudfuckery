#!/usr/bin/env ruby

require 'aws-sdk'

=begin
puts "enter the access key"
access_key = gets.chomp!

puts "enter the secret key"
secret_key = gets.chomp!
=end

ec2 = Aws::EC2::Client.new(
    access_key_id: ENV['AWS_ACCESS_KEY'],
    secret_access_key: ENV['AWS_SECRET_KEY'],
    region: 'us-east-1'
)
ec2.describe_instances.reservations.each do |instance|
  puts instance[:groups]
end