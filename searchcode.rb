require 'optparse'

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


args = ARGV.empty? ? %w{--help} : ARGV
options = Parser.parse args
p options if args.include?('--help')


