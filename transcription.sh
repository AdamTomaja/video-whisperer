#!/bin/bash
chunks_dir="chunks"
txtx_dir="txts"
audio_file="audio.mp3"
md_file="temp.md"
pdf_file="output.pdf"

# Set the path to your OpenAI API key
# Check if OPENAI_API_KEY is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "ERROR: OPENAI_API_KEY is not set."
    exit 1
else
    echo "OPENAI_API_KEY is set to: $OPENAI_API_KEY"
    # Continue with your script logic here
fi

# Check if input_file is provided as an argument
if [ -z "$1" ]; then
    echo "ERROR: input_file is not provided."
    exit 1
fi

# Assign the input_file argument to a variable
input_file="$1"
# Continue with your script logic using the input_file variable
echo "input_file is set to: $input_file"

# Check if input_file is provided as an argument
if [ -z "$2" ]; then
    echo "ERROR: work_dir is not provided."
    exit 1
fi

# Assign the work_dir argument to a variable
work_dir="$2"
# Continue with your script logic using the input_file variable
echo "work_dir is set to: $work_dir"

# Output PDF file name
output_pdf="$work_dir/$pdf_file"

# Temporary Markdown file
temp_md="$work_dir/$md_file"

echo "Creating workdir $work_dir"

mkdir "$work_dir"
mkdir "$work_dir/$chunks_dir"
mkdir "$work_dir/$txtx_dir"

 
# # # Extract audio from mkv video
ffmpeg -i "$input_file" -map 0:a -acodec libmp3lame "$work_dir/$audio_file"

# ## Split to mp3 files with 1200 seconds fragment size
ffmpeg -i "$work_dir/$audio_file" -f segment -segment_time 1200 -c copy "$work_dir/$chunks_dir/mp3_part_%03d.mp3"

# Transcribe each mp3 file and save the results to text files with numerical prefixes
count=1
for file in "$work_dir/$chunks_dir"/mp3_part_*.mp3; do
  echo "Transcribing file: $file"
  filename=$(basename "$work_dir/$chunks_dir/$file")
  filename_without_extension="${filename%.*}"
  curl https://api.openai.com/v1/audio/transcriptions \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-Type: multipart/form-data" \
    -F model="whisper-1" \
    -F file=@"$file" \
    -o "$work_dir/$txtx_dir/$filename_without_extension".txt
  ((count++))
done

# Iterate through each text file in the directory
for file in "$work_dir/$txtx_dir"/mp3_part_*.txt; do
    # Extract the text from JSON structure using jq and save it to the temporary Markdown file
    jq -r '.text' "$file" >> "$temp_md"
    echo "" >> "$temp_md"  # Add an empty line between each text
done

# Convert the temporary Markdown file to PDF using pandoc
pandoc -f markdown -o "$output_pdf" "$temp_md"

echo "PDF file '$output_pdf' created successfully."