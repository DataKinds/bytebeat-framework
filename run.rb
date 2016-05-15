#!/usr/bin/env ruby
ss=File.read(ARGV[0]).chomp
f=File.open("~temp.c", "w")
f.write(DATA.read.gsub(/REPLACE_ME/, ss))
f.close
`gcc "~temp.c" -o lastMusic.out`
`rm "~temp.c"`
`./lastMusic.out | aplay`
__END__
#include "instrument.c"
int main() {
	unsigned int t = 0;
	for(;;t++){
		putchar(REPLACE_ME);
	}
}
