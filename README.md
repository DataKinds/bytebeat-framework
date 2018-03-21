bytebeat-framework
===
A Ruby script to ease the creation of bytebeat music, through special .music files.

Usage
---
With `bytebeat.rb` in the same folder as the `c` folder, simply run

    bytebeat.rb <music file>

and a `music.out` file will appear in your current directory ready to run. Check out some example `.music` files in the `examples/` folder to see how to create one for yourself.

Who's idea was this?
---
Check out the original blog post at http://canonical.org/~kragen/bytebeat/.

Built-in help menu
---
```
Usage: bytebeat.rb [options] [input file]
Note: You must have gcc (or a compatible compiler) installed.
      You must have aplay installed to use `-r`.

    -o, --output OUTPUTFILE          Specify the file to output the compiled binary to (default music.out).
    -r, --run-aplay                  Run the music file after compilation, using `aplay`.
    -c, --compiler COMPILER          Specify another compiler to use over `gcc`.
    -k, --keep-temp                  Keep the processed files produced before compilation.
        --no-instrument              Don't compile in the `instrument.c` file.
    -h, --help                       Print this message.
```
