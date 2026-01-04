#!/usr/bin/env bash

# Get system information
host=$(uname -n)
user=$(whoami)
kernel="$(uname -r)"
shell="$(basename "${SHELL}")"
os="$(uname -s)"

# Get uptime in a cross-platform way
if [[ "$os" == "Darwin" ]]; then
    # macOS
    uptime_seconds=$(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')
    current_time=$(date +%s)
    uptime_duration=$((current_time - uptime_seconds))
    days=$((uptime_duration / 86400))
    hours=$(((uptime_duration % 86400) / 3600))
    minutes=$(((uptime_duration % 3600) / 60))

    if [[ $days -gt 0 ]]; then
        uptime="up $days days, $hours hours, $minutes minutes"
    elif [[ $hours -gt 0 ]]; then
        uptime="up $hours hours, $minutes minutes"
    else
        uptime="up $minutes minutes"
    fi
elif [[ "$os" == "Linux" ]]; then
    # Linux - check if uptime supports -p flag
    if uptime -p >/dev/null 2>&1; then
        uptime="$(uptime -p)"
    else
        # Fallback for older Linux systems
        uptime_info=$(uptime | sed 's/.*up \([^,]*\).*/\1/')
        uptime="up $uptime_info"
    fi
else
    # Generic fallback
    uptime="$(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | sed 's/^ *//')"
    uptime="up $uptime"
fi

# Get battery information
battery="N/A"
if [[ "$os" == "Linux" ]]; then
    if [[ -d /sys/class/power_supply ]]; then
        for bat in /sys/class/power_supply/BAT*; do
            [[ -e "$bat" ]] || continue
            if [[ -f "$bat/capacity" ]]; then
                battery="$(cat "$bat/capacity")%"
                break
            fi
        done
    fi
elif [[ "$os" == "Darwin" ]]; then
    if command -v pmset &> /dev/null; then
        batt_val=$(pmset -g batt | grep -Eo '[0-9]+%' | head -1)
        if [[ -n "$batt_val" ]]; then
            battery="$batt_val"
        fi
    fi
fi

# CPU detection
cpu="Unknown"
if [[ "$os" == "Linux" ]]; then
    if [[ -f /proc/cpuinfo ]]; then
        cpu=$(awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo)
    fi
elif [[ "$os" == "Darwin" ]]; then
    cpu=$(sysctl -n machdep.cpu.brand_string)
fi

# GPU detection
gpu="Unknown"
if [[ "$os" == "Linux" ]]; then
    if command -v lspci &> /dev/null; then
        gpu_info=$(lspci | grep -E -i "vga|3d|2d" | head -n 1)
        if [[ -n "$gpu_info" ]]; then
             # Try to extract the name after the class info
             gpu=$(echo "$gpu_info" | sed 's/^.*: //')
        fi
    fi
elif [[ "$os" == "Darwin" ]]; then
    gpu_info=$(system_profiler SPDisplaysDataType 2>/dev/null | grep "Chipset Model" | head -n 1 | awk -F': ' '{print $2}')
    if [[ -n "$gpu_info" ]]; then
        gpu="$gpu_info"
    fi
fi

# Color definitions
c1=$(printf "\e[42m  \e[0m")
c2=$(printf "\e[41m  \e[0m")
c3=$(printf "\e[43m  \e[0m")
c4=$(printf "\e[44m  \e[0m")
c5=$(printf "\e[45m  \e[0m")

# Foreground color definitions
f1=$(printf "\e[32m")
f2=$(printf "\e[31m")
f3=$(printf "\e[33m")
f4=$(printf "\e[34m")
f5=$(printf "\e[35m")
f6=$(printf "\e[36m")
f7=$(printf "\e[95m")
rst=$(printf "\e[0m")

# Icon definitions
ic_os=""
ic_host=""
ic_user=""
ic_kernel=""
ic_shell=""
ic_time=""
ic_battery=""
ic_cpu=""
ic_gpu=""

cat <<EOF

${c1} ┌───┐   ${f1}${ic_os} os    ${rst} : ${os}
${c2} │ ┌─┼─┐ ${f2}${ic_host} host  ${rst} : ${host}
${c3} │ │ │ │ ${f3}${ic_user} user  ${rst} : ${user}
${c4} └─┼─┘ │ ${f4}${ic_kernel} kernel${rst} : ${kernel}
${c5}   └───┘ ${f5}${ic_shell} shell ${rst} : ${shell}
           ${f6}${ic_cpu} cpu   ${rst} : ${cpu}
           ${f7}${ic_gpu} gpu   ${rst} : ${gpu}

${ic_battery} ${battery}
${ic_time} ${uptime}

EOF
