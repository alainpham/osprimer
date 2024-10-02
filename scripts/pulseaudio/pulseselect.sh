#!/bin/bash

# Get list of input devices (sources)
input_devices=$(pactl list short sources | grep alsa_input | awk '{print $2}')

output_devices=$(pactl list short sinks | grep alsa_output | awk '{print $2}')

echo "Available Input Devices:"
i=1
for device in $input_devices; do
echo "$i) $device"
((i++))
done

# Prompt user to select input device
read -p "Select input device (1-$((i-1))): " input_choice

selected_input=$(echo "$input_devices" | sed -n "${input_choice}p")
if [ -n "$selected_input" ]; then
echo "Selected input device: $selected_input"
else
echo "Invalid selection. Exiting."
exit 1
fi

# If output device is selected
echo "Available Output Devices:"
i=1
for device in $output_devices; do
echo "$i) $device"
((i++))
done

# Prompt user to select output device
read -p "Select output device (1-$((i-1))): " output_choice

selected_output=$(echo "$output_devices" | sed -n "${output_choice}p")
if [ -n "$selected_output" ]; then
echo "Selected output device: $selected_output"
else
echo "Invalid selection. Exiting."
exit 1
fi

#comma separated list of sinks
speakers=$selected_output

mic=$selected_input
pactl list short | grep module-combine-sink.*cspeakers | awk '{print $1}' | xargs -r -n 1 pactl unload-module
pactl load-module module-combine-sink sink_name=cspeakers sink_properties=device.description=cspeakers slaves=${speakers}

# connect from-desktop to speakers
pactl load-module module-loopback source="from-desktop.monitor" sink="cspeakers" latency_msec=1 source_dont_move=true sink_dont_move=true rate=48000 adjust_time=0

# connect from-caller to speakers
pactl load-module module-loopback source="from-caller.monitor" sink="cspeakers" latency_msec=1 source_dont_move=true sink_dont_move=true rate=48000 adjust_time=0


# split mic into 2
pactl list short | grep module-remap-source.*mic01-processed | awk '{print $1}' | xargs -r -n 1 pactl unload-module
pactl load-module module-remap-source source_name=mic01-processed master=${mic} master_channel_map="front-left" channel_map="mono" source_properties=device.description="mic01-processed"

pactl list short | grep module-remap-source.*mic02-processed | awk '{print $1}' | xargs -r -n 1 pactl unload-module
pactl load-module module-remap-source source_name=mic02-processed master=${mic} master_channel_map="front-right" channel_map="mono" source_properties=device.description="mic02-processed"

pactl list short | grep module-remap-source.*mics-raw | awk '{print $1}' | xargs -r -n 1 pactl unload-module
pactl load-module module-remap-source source_name=mics-raw master=${mic} source_properties=device.description="mics-raw"

pactl load-module module-loopback source="mic01-processed" sink=to-caller-sink latency_msec=1 source_dont_move=true sink_dont_move=true rate=48000 adjust_time=0
pactl load-module module-loopback source="mic02-processed" sink=to-caller-sink latency_msec=1 source_dont_move=true sink_dont_move=true rate=48000 adjust_time=0
