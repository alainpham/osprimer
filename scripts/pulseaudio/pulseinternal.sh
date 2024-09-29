#!/bin/bash
speaker=alsa_output.pci-0000_00_1b.0.analog-stereo

mic=alsa_input.pci-0000_00_1b.0.analog-stereo

# connect from-desktop to speakers
pactl load-module module-loopback source="from-desktop.monitor" sink="${speaker}" latency_msec=1

# connect from-caller to speakers
pactl load-module module-loopback source="from-caller.monitor" sink="${speaker}" latency_msec=1

# split mic into 2
pactl load-module module-remap-source source_name=mic01-processed master=${mic} master_channel_map="front-left" channel_map="mono" source_properties=device.description="mic01-processed"
pactl load-module module-remap-source source_name=mic02-processed master=${mic} master_channel_map="front-right" channel_map="mono" source_properties=device.description="mic02-processed"
pactl load-module module-remap-source source_name=mics-raw master=${mic} source_properties=device.description="mics-raw"

pactl load-module module-loopback source="mic01-processed" sink=to-caller-sink latency_msec=1 source_dont_move=true sink_dont_move=true
pactl load-module module-loopback source="mic02-processed" sink=to-caller-sink latency_msec=1 source_dont_move=true sink_dont_move=true
