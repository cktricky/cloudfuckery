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
  
  
  def initialize(hash={})
    length_info = get_length_values(hash)
    make_titles(length_info)
  end
  
  def get_length_values(hash={})
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
  
  def make_titles(length_info={})
    title = ""
    title << "Category\n" 
    title << "=" * 8
    title << ' ' * (length_info[:key_length] - 8 + 1)
    puts title.inspect
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


