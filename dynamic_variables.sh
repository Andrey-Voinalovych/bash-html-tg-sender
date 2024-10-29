# Here set all dynamic variables that you want to be calculated when request is send
# Dictionary keys = {{key}} in html template that you want to change. 
# Ex.: If in html you passed {{cpu_usage}}, html_vars["cpu_usage"] calculated value 
# will be generated and passed in your template

declare -A html_vars
initialize_dynamic_variables(){
    html_vars["user"]=$(whoami)
    html_vars["uptime"]=$(uptime -p)
    html_vars["cpu_usage"]=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    html_vars["mem_usage"]=$(free -h | awk 'NR==2{printf "%s/%s (%.2f%%)\n", $3,$2,$3*100/$2 }')
}