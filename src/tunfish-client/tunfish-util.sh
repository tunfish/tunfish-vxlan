# ==========
# Networking
# ==========

probe_members_ip() {

    # Obtain list if IP addresses to monitor until becoming reachable
    members=$@

    # Total number of members
    member_count=${#members[@]}

    # Run the monitor
    echo -e "INFO:  Waiting for IP connectivity of $(mvalue ${member_count}) members for $(mvalue ${PROBE_IP_TIMEOUT}) seconds each"
    failed_count=0
    failed_members=()
    for ip in ${members[@]}; do
        COUNTER=0
        success=false
        while [ $COUNTER -lt $PROBE_IP_TIMEOUT ]; do
            echo "INFO:  Sending ICMP request to $ip"
            if ping -c1 -w1 $ip >>/dev/null 2>&1; then
                let success_count=success_count+1
                success=true
                break
            fi
            let COUNTER=COUNTER+1
            sleep 1
        done
        if $success; then
            echo -e "$(msuccess "INFO:  Address") $(mvalue $ip) $(msuccess "is reachable")"
        else
            echo -e "$(mwarning "WARN:  Address") $(mvalue $ip) $(mwarning "is not reachable"), giving up after $(mvalue ${PROBE_IP_TIMEOUT}) seconds"
            failed_members+=($ip)
            let failed_count=failed_count+1
        fi
    done

    # Evaluate monitoring outcome
    if [ $failed_count -eq 0 ]; then
        echo
        echo -e "${color_green}${color_bold}Self-testing indicates your Tunfish network has been established successfully. Excellent.${color_reset}"
        echo "Have fun!"
        echo
    else
        echo -e -n "${color_red}${color_bold}"
        echo "ERROR: Self-testing did not succeed, it looks like there's a problem somewhere"
        echo -e -n "${color_reset}"
        echo
        echo -e "WARN:  Connectivity to $(mvalue ${failed_count}) members failed"
        echo -e "WARN:  The failed members are $(mwarning ${failed_members})"
        echo
        exit 133
    fi

}

# ======
# Colors
# ======

# https://misc.flogisoft.com/bash/tip_colors_and_formatting
color_lightblue="\e[94m"
color_blue="\e[34m"
color_yellow="\e[93m"
color_green="\e[32m"
color_red="\e[31m"
color_white="\e[97m"
color_bold="\e[1m"
color_reset="\e[0m"

msection() {
    echo -e "${color_white}${color_bold}${1}${color_reset}"
}
mvalue() {
    echo -e "${color_yellow}${color_bold}${1}${color_reset}"
}
msuccess() {
    echo -e "${color_green}${color_bold}${1}${color_reset}"
}
minfo() {
    echo -e "${color_lightblue}${color_bold}${1}${color_reset}"
}
mwarning() {
    echo -e "${color_red}${color_bold}${1}${color_reset}"
}
