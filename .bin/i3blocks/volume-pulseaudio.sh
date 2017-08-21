#!/bin/bash
# Displays the default device, volume, and mute status for i3blocks

AUDIO_HIGH_SYMBOL='  '

AUDIO_MED_THRESH=50
AUDIO_MED_SYMBOL='  '

AUDIO_LOW_THRESH=0
AUDIO_LOW_SYMBOL='  '

AUDIO_MUTED_SYMBOL='  '

DEFAULT_COLOR="#ffffff"
MUTED_COLOR="#a0a0a0"

LONG_FORMAT=0
SHORT_FORMAT=2
USE_PERCENT=1
USE_ALSA_NAME=0

SUBSCRIBE=0

while getopts F:Sf:paH:M:L:X:T:t:C:c:h opt; do
    case "$opt" in
        S) SUBSCRIBE=1 ;;
        F) LONG_FORMAT="$OPTARG" ;;
        f) SHORT_FORMAT="$OPTARG" ;;
        p) USE_PERCENT=0 ;;
        a) USE_ALSA_NAME=1 ;;
        H) AUDIO_HIGH_SYMBOL="$OPTARG" ;;
        M) AUDIO_MED_SYMBOL="$OPTARG" ;;
        L) AUDIO_LOW_SYMBOL="$OPTARG" ;;
        X) AUDIO_MUTED_SYMBOL="$OPTARG" ;;
        T) AUDIO_MED_THRESH="$OPTARG" ;;
        t) AUDIO_LOW_THRESH="$OPTARG" ;;
        C) DEFAULT_COLOR="$OPTARG" ;;
        c) MUTED_COLOR="$OPTARG" ;;
        h) printf \
"Usage: volume-pulseaudio [-S] [-F format] [-f format] [-p] [-a] [-H symb] [-M symb]
        [-L symb] [-X symb] [-T thresh] [-t thresh] [-C color] [-c color] [-h]
Options:
-F, -f\tOutput format (-F long format, -f short format) to use, amonst:
\t0\t symb vol [index:name]\t (default long)
\t1\t symb vol [name]
\t2\t symb vol [index]\t (default short)
\t3\t symb vol
-S\tSubscribe to volume events (requires persistent block, always uses long format)
-p\tOmit the percent sign (%%) in volume
-a\tUse ALSA name if possible
-H\tSymbol to use when audio level is high. Default: '$AUDIO_HIGH_SYMBOL'
-M\tSymbol to use when audio level is medium. Default: '$AUDIO_MED_SYMBOL'
-L\tSymbol to use when audio level is low. Default: '$AUDIO_LOW_SYMBOL'
-X\tSymbol to use when audio is muted. Default: '$AUDIO_MUTED_SYMBOL'
-T\tThreshold for medium audio level. Default: $AUDIO_MED_THRESH
-t\tThreshold for low audio level. Default: $AUDIO_LOW_THRESH
-C\tColor for non-muted audio. Default: $DEFAULT_COLOR
-c\tColor for muted audio. Default: $MUTED_COLOR
-h\tShow this help text
" && exit 0;;
    esac
done

function set_default_playback_device_next {
    inc=${1:-1}
    num_devices=$(pacmd list-sinks | grep -c index:)
    sink_arr=($(pacmd list-sinks | grep index: | grep -o '[0-9]\+'))
    default_sink_index=$(( $(pacmd list-sinks | grep index: | grep -no '*' | grep -o '^[0-9]\+') - 1 ))
    default_sink_index=$(( ($default_sink_index + $num_devices + $inc) % $num_devices ))
    default_sink=${sink_arr[$default_sink_index]}
    pacmd set-default-sink $default_sink
}

case "$BLOCK_BUTTON" in
    1) amixer -q set Master toggle ;;
    3) pavucontrol &;;
    4) amixer -q set Master 5%+ unmute;;
    5) amixer -q set Master 5%- unmute;;
esac

function print_format {
    PERCENT="%"
    [[ $USE_PERCENT == 0 ]] && PERCENT=""
    case "$1" in
        1) echo "$SYMBOL$VOL$PERCENT [$NAME]" ;;
        2) echo "$SYMBOL$VOL$PERCENT [$INDEX]";;
        3) echo "$SYMBOL$VOL$PERCENT" ;;
        *) echo "$SYMBOL$VOL$PERCENT [$INDEX:$NAME]" ;;
    esac
}

function print_block {
    for name in INDEX NAME VOL MUTED; do
        read $name
    done < <(pacmd list-sinks | grep "index:\|name:\|volume: front\|muted:" | grep -A3 '*')
    INDEX=$(echo "$INDEX" | grep -o '[0-9]\+')
    VOL=$(echo "$VOL" | grep -o "[0-9]*%" | head -1 )
    VOL="${VOL%?}"

    NAME=$(echo "$NAME" | sed \
's/.*<.*\.\(.*\)>.*/\1/; t;'\
's/.*<\(.*\)>.*/\1/; t;'\
's/.*/unknown/')

    if [[ $USE_ALSA_NAME == 1 ]] ; then
        ALSA_NAME=$(pacmd list-sinks |\
awk '/^\s*\*/{f=1}/^\s*index:/{f=0}f' |\
grep "alsa.name\|alsa.mixer_name" |\
head -n1 |\
sed 's/.*= "\(.*\)".*/\1/')
        NAME=${ALSA_NAME:-$NAME}
    fi

    if [[ $MUTED =~ "no" ]] ; then
        SYMBOL=$AUDIO_HIGH_SYMBOL
        [[ $VOL -le $AUDIO_MED_THRESH ]] && SYMBOL=$AUDIO_MED_SYMBOL
        [[ $VOL -le $AUDIO_LOW_THRESH ]] && SYMBOL=$AUDIO_LOW_SYMBOL
        COLOR=$DEFAULT_COLOR
    else
        SYMBOL=$AUDIO_MUTED_SYMBOL
        COLOR=$MUTED_COLOR
    fi

    if [[ $SUBSCRIBE == 1 ]] ; then
        print_format "$LONG_FORMAT"
    else
        print_format "$LONG_FORMAT"
        print_format "$SHORT_FORMAT"
        echo "$COLOR"
    fi
}

print_block
if [[ $SUBSCRIBE == 1 ]] ; then
    while read -r EVENT; do
        print_block
    done < <(pactl subscribe | stdbuf -oL grep change)
fi
