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
	opts.separator "Note: You must have gcc (or a compatible compiler) installed."
	opts.separator "      You must have aplay installed to use `-r`."
	opts.separator ""
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

# this may or may not be empty. if it's empty, handle it later
options[:inputFile] = ARGV[0]

tempFileName = "~#{options[:outputFile].split(?.).first.split(?/).last}.c"

music = ""
# handle an empty input file
if options[:inputFile].nil?
	music = STDIN.read
else
# as long as the input file was supplied, read it
	File.open(options[:inputFile], "r") do |inputFile|
		music = inputFile.read
	end
end
# then generate the temporary C file
File.open(tempFileName, "w") do |tempFile|
	processedC = DATA.read.gsub(/REPLACE_ME/, music)
	if options[:noInstrument]
		processedC = processedC.split(?\n)[1..-1].join(?\n)
	end
	tempFile.write processedC
end
# and compile the C file(s)
if options[:noInstrument]
	puts "#{options[:defaultCompiler]} \"#{tempFileName}\" -o \"#{options[:outputFile]}\""
	puts `#{options[:defaultCompiler]} "#{tempFileName}" -o "#{options[:outputFile]}"`
else
	puts "#{options[:defaultCompiler]} \"#{tempFileName}\" c/instrument.c -o \"#{options[:outputFile]}\""
	puts `#{options[:defaultCompiler]} "#{tempFileName}" c/instrument.c -o "#{options[:outputFile]}"`
end
# delete the C file if the user wants us to
unless options[:keepTemp]
	`rm "#{tempFileName}"`
end
# then run the output file if the user wants us to
if options[:willRun]
	puts "chmod +x #{options[:outputFile]}"
	`chmod +x #{options[:outputFile]}`
	puts "./#{options[:outputFile]} | aplay"
	puts `./#{options[:outputFile]} | aplay`
end
__END__
#include <stdio.h>
#include "c/instrument.h"
int main() {
	unsigned int t = 0;
	for(;;t++){
		putchar(REPLACE_ME);
	}
}
