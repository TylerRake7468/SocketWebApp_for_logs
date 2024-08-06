LOG_FILE="/home/lalitmali/Desktop/rails7/websocket_app/logfile.log"

while true; do
  echo "New log entry at $(date)" >> "$LOG_FILE"
  sleep 1
done