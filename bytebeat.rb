#!/usr/bin/env ruby
require "optparse"
options = {}
OptionParser.new do |opts|
	options[:outputFile] = "music.out"
	options[:inputFile] = "main.music"
	options[:willRun] = false
	options[:defaultCompiler] = "gcc"
	options[:keepTemp] = false
	options[:noInstrument] = false

	opts.banner = "Usage: bytebeat.rb [options] [input file]"
	opts.seperator "Note: You must have gcc (or a compatible compiler) installed."
	opts.seperator "      You must have aplay installed to use `-r`."
	opts.seperator ""
	opts.on("-o", "--output OUTPUTFILE", "Specify the file to output the compiled binary to (default music.out).") do |out|
		options[:outputFile] = out
	end
	opts.on("-r", "--run-aplay", "Run the music file after compilation, using `aplay`.") do
		options[:willRun] = true
	end
	opts.on("-c", "--compiler COMPILER", "Specify another compiler to use over `gcc`.") do |compiler|
		options[:defaultCompiler] = compiler
	end
	opts.on("-k", "--keep-temp", "Keep the processed files produced before compilation.") do
		options[:keepTemp] = true
	end
	opts.on("--no-instrument", "Don't compile in the `instrument.c` file.") do
		options[:noInstrument] = true
	end

	opts.on_tail("-h", "--help", "Print this message.") do
		puts opts
		exit
	end
end.parse!

if ARGV then
	# if an input file was supplied after everything was parsed & done
	options[:inputFile] = ARGV[0]
end
tempFileName = "~#{options[:outputFile].split(?.).first}.c"
File.open(options[:inputFile], "r") do |inputFile|
	File.open(tempFileName, "w") do |tempFile|
		music = inputFile.read
		processedC = DATA.read.gsub(/REPLACE_ME/, music)
		if options[:noInstrument]
			processedC = processedC.split(?\n)[1..-1].join(?\n)
		end
		tempFile.write()
	end
end
puts `#{options[:defaultCompiler]} "#{tempFileName}" -o "#{options[:outputFile]}"`
unless options[:keepTemp]
	`rm "~temp.c"`
end
if options[:willRun]
	puts "chmod +x #{options[:outputFile]}"
	`chmod +x #{options[:outputFile]}`
	puts "./#{options[:outputFile]} | aplay"
	puts `./#{options[:outputFile]} | aplay`
end
__END__
#include "c/instrument.c"
int main() {
	unsigned int t = 0;
	for(;;t++){
		putchar(REPLACE_ME);
	}
}
