require 'optparse'

Options = Struct.new(:name)

class Parser
  def self.parse(options)
    args = Options.new("world")

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"

      opts.on("-oORG REPO URL", "--name=ORG REPO URL", "Organization's GitHub Link, Ex: https://github.com/twitter") do |o|
        args.org_url = o
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
p options


