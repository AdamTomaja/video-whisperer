# Audio Transcription Script

This repository contains a Bash script that can be used to transcribe audio files using the OpenAI Whisper API. The script performs the following tasks:

1. Extracts audio from a video file and saves it as an MP3 file.
2. Splits the audio file into smaller segments of 20 minutes each.
3. Transcribes each segment using the OpenAI Whisper API and saves the transcriptions as text files.
4. Combines the transcriptions into a single Markdown file.
5. Converts the Markdown file to a PDF document.

## Prerequisites

Before using the script, make sure you have the following:

- An OpenAI API key. Set the `OPENAI_API_KEY` environment variable with your API key.
- FFmpeg: A multimedia framework for handling audio and video files. You can install it by following the instructions for your operating system.
- jq: A lightweight and flexible command-line JSON processor. You can install it by following the instructions for your operating system.
- pandoc: A universal document converter. You can install it by following the instructions for your operating system.

## Usage

1. Clone this repository to your local machine.
2. Open a terminal and navigate to the repository directory.
3. Run the script with the following command:

```bash
./transcribe.sh input_file work_dir