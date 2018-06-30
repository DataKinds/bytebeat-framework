#include <SDL2/SDL.h>
#include <string.h>
#include "instrument.c"

int f(unsigned int t) {
    //TODO
    return frequency(t, 880, 1);
}


void audio_callback(void* userdata, Uint8* stream, int len) {
    for (int i = 0; i < len; i++) {
        unsigned int* t;
        t = userdata;
        (*t)++;
        stream[i] = f(*t);
    }
}

int main(int argc, char** argv) {
    if (SDL_Init(SDL_INIT_VIDEO|SDL_INIT_AUDIO) != 0) {
        SDL_Log("Unable to initialize SDL: %s", SDL_GetError());
        return 1;
    }
    
    SDL_Window* win = SDL_CreateWindow("Bytebeat Visualizer", 0, 0, 800, 600, 0);
    SDL_Renderer* ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED);
    
    SDL_AudioSpec want, have;
    SDL_AudioDeviceID dev;
    SDL_zero(want); SDL_zero(have);
    want.freq = 8000;
    want.format = AUDIO_U8;
    want.channels = 1;
    want.samples = 4096;
    want.callback = audio_callback;
    // save the current time
    want.userdata = malloc(sizeof(unsigned int));
    memset(want.userdata, 0, sizeof(unsigned int));
    dev = SDL_OpenAudioDevice(NULL, 0, &want, &have, 0);
    
    SDL_PauseAudioDevice(dev, 0);
    int running = 1;
    while (running) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            switch (e.type) {
                case SDL_QUIT:
                running = 0;
                break;
            }
        }
    }
    
    SDL_CloseAudioDevice(dev);
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
}