require "sdl2"

class Visualizer
    @win = nil
    @ren = nil
    @musicPath = ""
    def initialize(musicPath)
        SDL2.init(SDL2::INIT_EVERYTHING)
        @musicPath = musicPath
    end

    def read1s(music, bits, bitrate)
        out = []
        (bitrate / bits).times do
            out << music.readbyte
        end
        return out
    end
    def read1sDefault(music)
        return read1s(music, 8, 8192)
    end

    def mainLoop()
        @win = SDL2::Window.create("Bytebeat Visualizer", 0, 0, 800, 600, 0)
        @ren = @win.create_renderer(-1, SDL2::Renderer::Flags::ACCELERATED)
        p Dir["*"]
        IO.popen([File.expand_path(@musicPath)]) do |music|
            loop do
                # first, clear the screen
                @ren.draw_color = [0, 0, 0]
                @ren.clear

                case SDL2::Event.poll
                when SDL2::Event::Quit
                    exit
                end
                lastSecondSample = read1sDefault(music)
                # then, draw the lines
                (lastSecondSample.length - 2).times do |i|
                    y = lastSecondSample[i]
                    x = i
                end
                @ren.draw_color = [255, 255, 255]
                @ren.draw_line(0, 0, 800, 600)
                @ren.present
                sleep 0.01
            end
        end
    end
end
