require 'optparse'
require 'json'
require 'open-uri'


Options = Struct.new(:name)

class Parser
  def self.parse(options)
    args = Options.new("world")

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"

      opts.on("-nOrgName", "--name=Org Name", "IMPORTANT: Organization's name as seen on GitHub") do |n|
        args.name = n
      end

      opts.on("-h", "--help", "Prints available options") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end

class PrintTable
  
  attr_reader :hash, :length_info
  
  def initialize(hash={})
    @hash = hash
    @length_info = get_length_values
    make_titles
    print_user_details
  end
  
  def get_length_values
    key_lengths = []
    val_lengths = []
    hash.each do |key, value|
      key_lengths << key.to_s.length
      val_lengths << value.to_s.length
    end
    { :key_length => key_lengths.sort_by(&:to_i).last, 
      :value_length => val_lengths.sort_by(&:to_i).last
    }
  end
  
  def make_titles
    title = ''
    title << "User" + ' ' * length_info[:key_length]
    title << "Details" + ' ' * length_info[:value_length]
    title << "\n" + '=' * 4
    title << " " * (length_info[:key_length])
    title << '=' * 7 + "\n\n"
    puts title
  end
  
  def print_user_details
    detail = ""
    hash.each do |key, value| 
      detail << key + ' ' * (length_info[:key_length] - key.length + 4)
      detail << value.to_s
      detail << "\n"
    end
    detail << "\n"
    puts detail
  end
  
end

class GetOrgMembers
  
  attr_reader :name
  
  def initialize(options=Struct.new)
    @name = options.name
  end
  
  def fetch
    @members = JSON.parse(open("https://api.github.com/orgs/#{name}/members").read)
  rescue OpenURI::HTTPError => e
    e
  end
  
  def print_relevant_details
    if @members.nil?
     puts "No members Returned, Sorry"
     exit
    end
    @members.each do |member|
      PrintTable.new(member)
    end
  end

end

args = ARGV.empty? ? %w{--help} : ARGV
options = Parser.parse args
p options if args.include?('--help')

members = GetOrgMembers.new(options)
members.fetch
members.print_relevant_details


