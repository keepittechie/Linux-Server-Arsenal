#!/bin/bash

# Variables
SERVICE_USER="transcriber"
BASE_DIR="/opt/transcription"
WATCH_DIR="/mnt/trans_vids"
OUTPUT_DIR="$BASE_DIR/output"
SCRIPT_DIR="$BASE_DIR/scripts"
LOG_DIR="$BASE_DIR/logs"
CACHE_DIR="$BASE_DIR/cache/huggingface"
WHISPER_BIN="/opt/whisper/venv/bin"
SERVICE_NAME="transcribe.service"
TIMER_NAME="transcribe.timer"

# Ensure the transcriber user has the correct home directory
echo "Setting home directory for $SERVICE_USER..."
sudo usermod -d $BASE_DIR $SERVICE_USER

# Create service account if it doesn't exist
if id "$SERVICE_USER" &>/dev/null; then
    echo "User $SERVICE_USER exists."
else
    echo "Creating service account..."
    sudo useradd -r -s /bin/false -d $BASE_DIR $SERVICE_USER
fi

# Create necessary directories
echo "Creating directories..."
sudo mkdir -p $WATCH_DIR $OUTPUT_DIR $SCRIPT_DIR $LOG_DIR $CACHE_DIR
sudo chown -R $SERVICE_USER:$SERVICE_USER $BASE_DIR
sudo chmod -R 755 $BASE_DIR

# Create the transcription script
echo "Creating transcription script..."
sudo tee $SCRIPT_DIR/transcribe.sh > /dev/null <<EOF
#!/bin/bash

WATCH_DIR="$WATCH_DIR"
OUTPUT_DIR="$OUTPUT_DIR"
LOG_DIR="$LOG_DIR"
SCRIPT_DIR="$SCRIPT_DIR"
HF_HOME="$CACHE_DIR"
WHISPER_BIN="$WHISPER_BIN"

# Set the HF_HOME environment variable to use the correct cache directory
export HF_HOME=\$HF_HOME

# Activate the virtual environment
source \$WHISPER_BIN/activate

# Ensure log directory exists
mkdir -p \$LOG_DIR

for file in "\$WATCH_DIR"/*.mp4; do
    [ -e "\$file" ] || continue  # Skip if no .mp4 files are found
    echo "Processing \$file" | tee -a \$LOG_DIR/transcription.log

    # Determine output file name
    output_file="\$OUTPUT_DIR/\$(basename "\${file%.mp4}.txt")"

    # Run the transcription
    python3 \$SCRIPT_DIR/trans.py "\$file" "\$output_file" >> \$LOG_DIR/transcription.log 2>&1

    # Check if the transcription was successful
    if [ \$? -eq 0 ]; then
        echo "Transcription successful, deleting \$file" | tee -a \$LOG_DIR/transcription.log
        rm "\$file"
    else
        echo "Transcription failed for \$file" | tee -a \$LOG_DIR/transcription.log
        echo "Check \$LOG_DIR/transcription.log for more details." | tee -a \$LOG_DIR/transcription.log
    fi
done

# Deactivate the virtual environment
deactivate
EOF

# Make the transcription script executable
sudo chmod +x $SCRIPT_DIR/transcribe.sh
sudo chown $SERVICE_USER:$SERVICE_USER $SCRIPT_DIR/transcribe.sh

# Create the Python transcription script
echo "Creating Python transcription script..."
sudo tee $SCRIPT_DIR/trans.py > /dev/null <<EOF
import os
import sys
import whisper

# Forcefully set HF_HOME and the download root directory
os.environ['HF_HOME'] = '/opt/transcription/cache/huggingface'
os.makedirs(os.environ['HF_HOME'], exist_ok=True)

# Load the small.en model using the forced cache directory
model = whisper.load_model("small.en", download_root=os.environ['HF_HOME'])

def transcribe_video(input_file, output_file):
    print(f"Starting transcription for: {input_file}")
    # Transcribe the audio
    result = model.transcribe(input_file)
    
    print(f"Transcription completed for: {input_file}")
    # Save the transcription to a text file
    with open(output_file, 'w') as f:
        f.write(result['text'])
    print(f"Transcription written to: {output_file}")

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    transcribe_video(input_file, output_file)
EOF

# Set the correct permissions for the Python script
sudo chown $SERVICE_USER:$SERVICE_USER $SCRIPT_DIR/trans.py

# Create the systemd service file
echo "Creating systemd service file..."
sudo tee /etc/systemd/system/$SERVICE_NAME > /dev/null <<EOF
[Unit]
Description=Transcribe videos in WATCH_DIR

[Service]
Type=simple
User=$SERVICE_USER
ExecStart=$SCRIPT_DIR/transcribe.sh
Environment="HF_HOME=$CACHE_DIR"
WorkingDirectory=$WATCH_DIR

[Install]
WantedBy=multi-user.target
EOF

# Create the systemd timer file to run every 15 minutes
echo "Creating systemd timer file..."
sudo tee /etc/systemd/system/$TIMER_NAME > /dev/null <<EOF
[Unit]
Description=Run Transcribe Service every 15 minutes

[Timer]
OnBootSec=5min
OnUnitActiveSec=5min
Unit=$SERVICE_NAME

[Install]
WantedBy=timers.target
EOF

# Reload systemd to apply changes
echo "Reloading systemd..."
sudo systemctl daemon-reload

# Enable transcibe service
echo "Enabling transcibe service..."
sudo systemctl enable $SERVICE_NAME

# Enable and start the timer service
echo "Enabling and starting the timer service..."
sudo systemctl enable $TIMER_NAME
sudo systemctl start $TIMER_NAME

echo "Setup complete. Please mount your share to $WATCH_DIR and start using the service."
