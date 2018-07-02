#include <SDL2/SDL.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "instrument.c"

int f(unsigned int t) {
    //TODO
    return frequency(t, 880, 1);
}


void audio_callback(void* userdata, Uint8* stream, int len) {
    unsigned int* t = userdata;
    for (int i = 0; i < len; i++) {
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
    // and save the pointer for further use
    unsigned int* t = want.userdata;
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

        SDL_SetRenderDrawColor(ren, 0, 0, 0, 255);
        SDL_RenderClear(ren);
        SDL_SetRenderDrawColor(ren, 255, 255, 255, 255);
        unsigned int i = (*t);
        i -= 8000;
        for (; i < *t; i++) {
            int x = 0;
            int sample_width = 1;
            SDL_RenderDrawLine(ren, x, 0, x + sample_width, 200);
            x++;
        }
        SDL_RenderPresent(ren);
    }

    SDL_CloseAudioDevice(dev);
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
}
