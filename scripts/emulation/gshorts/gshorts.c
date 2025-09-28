#include <SDL2/SDL.h>
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
    system("kill -9 $(pidof estation)");
    system("kill -9 $(pidof retroarch)");
    system("kill -9 $(pidof pcsx2) $(pidof AppRun.wrapped)");
    system("kill -9 $(pidof dolphin-emu)");
    system("kill -9 $(pidof cemu)");
    system("kill -9 $(pidof chrome)");
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

int main(int argc, char* argv[])
{
    
    int running=1;
    int btnModePressed = 0;
    int btnSelectPressed = 0;
    int btnStartPressed = 0;
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER) < 0) {
        SDL_Log("couldn't initialize SDL: %s", SDL_GetError());
        return 1;
    } else {
        SDL_Log("gshorts starting ..");
    }

    // In SDL2, "gamepad" API is called "GameController"
    // SDL will automatically send "controller device added" events
    SDL_GameController *controllers[4] = {0}; // support up to 4 controllers

    //special mapping
    const char *mapping =
    "0300d859bc2000000055000010010000,GameSir G3w,a:b0,b:b1,back:b10,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b12,leftshoulder:b6,leftstick:b13,lefttrigger:a5,leftx:a0,lefty:a1,rightshoulder:b7,rightstick:b14,righttrigger:a4,rightx:a2,righty:a3,start:b11,x:b3,y:b4,platform:Linux";

    int added = SDL_GameControllerAddMapping(mapping);
    if (added == 1) {
        SDL_Log("Mapping added for GameSir G3w!");
    } else if (added == 0) {
        SDL_Log("Mapping already existed, updated.");
    } else {
        SDL_Log("Failed to add mapping: %s", SDL_GetError());
    }
    // end special mappings

    while (running) {
        SDL_Event event;
        if (SDL_WaitEvent(&event)) {
            switch (event.type) {
                case SDL_QUIT:
                    running = 0;
                    SDL_Log("gshorts exiting ..");
                    break;

                case SDL_CONTROLLERDEVICEADDED: {
                    int which = event.cdevice.which;
                    if (SDL_IsGameController(which)) {
                        SDL_GameController *controller = SDL_GameControllerOpen(which);
                        if (controller) {
                            int index = SDL_JoystickInstanceID(SDL_GameControllerGetJoystick(controller));
                            controllers[index % 4] = controller;
                            SDL_Log("gamepad #%d ('%s') added", index, SDL_GameControllerName(controller));

                            const char *mapping = SDL_GameControllerMapping(controller);
                            if (mapping) {
                                SDL_Log("Mapping for controller #%d: %s", index, mapping);
                            } else {
                                SDL_Log("No mapping found for controller #%d", index);
                            }

                        } else {
                            SDL_Log("gamepad #%d add, but not opened: %s", which, SDL_GetError());
                        }
                    }
                } break;

                case SDL_CONTROLLERDEVICEREMOVED: {
                    SDL_JoystickID which = event.cdevice.which;
                    for (int i = 0; i < 4; i++) {
                        if (controllers[i] && SDL_JoystickInstanceID(SDL_GameControllerGetJoystick(controllers[i])) == which) {
                            SDL_GameControllerClose(controllers[i]);
                            controllers[i] = NULL;
                            SDL_Log("gamepad #%d removed", which);
                            break;
                        }
                    }
                } break;

                case SDL_CONTROLLERBUTTONDOWN:
                case SDL_CONTROLLERBUTTONUP: {
                    SDL_JoystickID which = event.cbutton.which;
                    int down = (event.type == SDL_CONTROLLERBUTTONDOWN);
    
                    if (event.cbutton.button == SDL_CONTROLLER_BUTTON_GUIDE) {
                        btnModePressed = down;
                        SDL_Log("gamepad #%d button GUIDE -> %s", which, down ? "PRESSED" : "RELEASED");
                    }

                    if (event.cbutton.button == SDL_CONTROLLER_BUTTON_START) {
                        btnStartPressed = down;
                        SDL_Log("gamepad #%d button START -> %s", which, down ? "PRESSED" : "RELEASED");
                    }

                    if (event.cbutton.button == SDL_CONTROLLER_BUTTON_BACK) {
                        btnSelectPressed = down;
                        SDL_Log("gamepad #%d button BACK -> %s", which, down ? "PRESSED" : "RELEASED");
                    }

                    if (btnModePressed && btnStartPressed) {
                        SDL_Log("trigger closing window");
                        trigger_exit();
                    }
                    if (btnModePressed && btnSelectPressed) {
                        SDL_Log("trigger launching ESDE");
                        launch_estation();
                    }
                } break;
            }
        }
    }

    // Cleanup
    for (int i = 0; i < 4; i++) {
        if (controllers[i]) {
            SDL_GameControllerClose(controllers[i]);
        }
    }

    SDL_Quit();
    return 0;
}



