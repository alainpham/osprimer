#include <SDL3/SDL.h>
#ifdef _WIN32
#include <windows.h>
#endif

void launch_estation() {
#ifdef _WIN32
    system("taskkill /IM ES-DE.exe /F");
    system("taskkill /IM pcsx2-qt.exe /F");
    system("taskkill /IM Dolphin.exe /F");
    system("taskkill /IM Cemu.exe /F");
    system("taskkill /IM retroarch.exe /F");
    system("start C:/apps/ES-DE/ES-DE.exe");
#else
    // --- Linux / Unix ---
    system("nohup estation >/dev/null 2>&1 &");
#endif
}

void trigger_exit() {
#ifdef _WIN32
    HWND hwnd = GetForegroundWindow();   // Get the currently active window
    if (hwnd) {
        PostMessage(hwnd, WM_CLOSE, 0, 0);  // Ask it to close (like Alt+F4)
    }
#else
    system("setxkbmap fr && xdotool key Super_L+c");
#endif
}

int main(){
    
    int running=1;
    int btnModePressed = 0;
    int btnSelectPressed = 0;
    int btnStartPressed = 0;

    if (!SDL_Init(SDL_INIT_GAMEPAD)) {
        SDL_Log("couldn't initialize SDL: %s", SDL_GetError());
        return 1;
    }else{
        SDL_Log("gshorts starting ..");
    }

    while (running){
        SDL_Event event;
        if (SDL_WaitEvent(&event)) {
            if (event.type == SDL_EVENT_QUIT) {
                running = false;
                SDL_Log("gshorts exiting ..");
            } else if (event.type == SDL_EVENT_GAMEPAD_ADDED) {
                /* this event is sent for each hotplugged 
                , but also each already-connected gamepad during SDL_Init(). */
                const SDL_JoystickID which = event.gdevice.which;
                SDL_Gamepad *gamepad = SDL_OpenGamepad(which);
                if (!gamepad) {
                    SDL_Log("gamepad #%u add, but not opened: %s", (unsigned int) which, SDL_GetError());
                } else {
                    char *mapping = SDL_GetGamepadMapping(gamepad);
                    SDL_Log("gamepad #%u ('%s') added", (unsigned int) which, SDL_GetGamepadName(gamepad));
                    if (mapping) {
                        SDL_Log("gamepad #%u mapping: %s", (unsigned int) which, mapping);
                        SDL_free(mapping);
                    }
                }
            } else if (event.type == SDL_EVENT_GAMEPAD_REMOVED) {
                const SDL_JoystickID which = event.gdevice.which;
                SDL_Gamepad *gamepad = SDL_GetGamepadFromID(which);
                if (gamepad) {
                    SDL_CloseGamepad(gamepad);  /* the gamepad was unplugged. */
                }
                SDL_Log("gamepad #%u removed", (unsigned int) which);
            } else if ((event.type == SDL_EVENT_GAMEPAD_BUTTON_UP) || (event.type == SDL_EVENT_GAMEPAD_BUTTON_DOWN)) {
                const SDL_JoystickID which = event.gbutton.which;

                if (event.gbutton.button==SDL_GAMEPAD_BUTTON_GUIDE)
                {
                    btnModePressed = event.gbutton.down;
                    SDL_Log("gamepad #%u button %s -> %s", (unsigned int) which, SDL_GetGamepadStringForButton((SDL_GamepadButton) event.gbutton.button), event.gbutton.down ? "PRESSED" : "RELEASED");
                }

                if (event.gbutton.button==SDL_GAMEPAD_BUTTON_START)
                {
                    btnStartPressed = event.gbutton.down;
                    SDL_Log("gamepad #%u button %s -> %s", (unsigned int) which, SDL_GetGamepadStringForButton((SDL_GamepadButton) event.gbutton.button), event.gbutton.down ? "PRESSED" : "RELEASED");
                }
                
                if (event.gbutton.button==SDL_GAMEPAD_BUTTON_BACK)
                {
                    btnSelectPressed = event.gbutton.down;
                    SDL_Log("gamepad #%u button %s -> %s", (unsigned int) which, SDL_GetGamepadStringForButton((SDL_GamepadButton) event.gbutton.button), event.gbutton.down ? "PRESSED" : "RELEASED");
                }

                if (btnModePressed && btnStartPressed) {
                    SDL_Log("trigger closing window");
                    trigger_exit();
                }
                if (btnModePressed && btnSelectPressed) {
                    SDL_Log("trigger launching ESDE");
                    launch_estation();
                }
            }
        }
    }

    return 0;
}



