#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <errno.h>
#include <linux/input.h>
#include <fcntl.h>
#include <sys/types.h>

static int find_js0_event(char *out, size_t out_size) {
    const char *path = "/sys/class/input/js0/device";
    DIR *dir = opendir(path);
    if (!dir) return -1;

    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        if (strncmp(entry->d_name, "event", 5) == 0) {
            snprintf(out, out_size, "/dev/input/%s", entry->d_name);
            closedir(dir);
            return 0;
        }
    }

    closedir(dir);
    return -1; // no eventXX found
}

int main(void) {
    char eventPath[256];
    struct input_event ev;
    int btnModePressed = 0;
    int btnSelectPressed = 0;
    int btnStartPressed = 0;

    int retry_delay = 2; // seconds
    while (1) {
        // === Outer loop: wait for joystick ===
        if (find_js0_event(eventPath, sizeof(eventPath)) != 0) {
            printf("No js0 event device, retrying in %d seconds...\n", retry_delay);
            sleep(retry_delay);
            continue;
        }

        printf("Found joystick at %s\n", eventPath);

        int fd = open(eventPath, O_RDONLY);
        if (fd < 0) {
            perror("open");
            continue;
        }

        // === Inner loop: process events ===
        while (1) {
            ssize_t n = read(fd, &ev, sizeof(ev));
            if (n == (ssize_t)sizeof(ev)) {
                if (ev.type == EV_KEY && ev.code == BTN_MODE) {
                    btnModePressed = (ev.value == 1);
                    printf("Mode button %s\n", btnModePressed ? "pressed" : "released");
                }

                if (ev.type == EV_KEY && ev.code == BTN_SELECT) {
                    btnSelectPressed = (ev.value == 1);
                    printf("Select button %s\n", btnSelectPressed ? "pressed" : "released");
                }

                if (ev.type == EV_KEY && ev.code == BTN_START) {
                    btnStartPressed = (ev.value == 1);
                    printf("Start button %s\n", btnStartPressed ? "pressed" : "released");
                }

                // Check for Mode + Select combination => run estation
                if (ev.type == EV_KEY && btnModePressed && btnSelectPressed) {
                    printf("Mode + Select detected!\n");
                    // Check if process "estation" exists and kill it
                    system("kill -9 $(pidof estation)");
                    system("kill -9 $(pidof retroarch)");
                    system("kill -9 $(pidof pcsx2)");
                    system("kill -9 $(pidof dolphin)");
                    system("kill -9 $(pidof cemu)");
                    system("kill -9 $(pidof chrome)");
                    system("nohup estation >/dev/null 2>&1 &");
                }

                // Check for Mode + Start combination => Super + C
                if (ev.type == EV_KEY && btnModePressed && btnStartPressed) {
                    printf("Mode + Start detected!\n");
                    system("setxkbmap fr && xdotool key Super_L+c");
                }

            } else if (n == -1) {
                if (errno == ENODEV || errno == EIO) {
                    printf("Controller disconnected!\n");
                } else {
                    perror("read");
                }
                break; // exit inner loop, close fd
            }
        }

        close(fd);

        // back to outer loop, wait before retry
        sleep(retry_delay);
    }

    return 0;
}
