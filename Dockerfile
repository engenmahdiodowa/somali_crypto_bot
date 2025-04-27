# Use an official Python 3.10 runtime as a parent image
FROM python:3.10-slim

# Set environment variables to prevent bytecode and ensure logs are output directly
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the timezone (optional, change if needed)
ENV TZ=America/New_York

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    python3-dev \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv (if needed, otherwise you can remove this line if not using pipenv)
RUN pip install --no-cache-dir pipenv

# Create a non-root user to run the application
RUN useradd -m appuser

# Switch to the non-root user
USER appuser

# Create a directory for the application
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY --chown=appuser:appuser . /app

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variables for Telegram bot
ENV TELEGRAM_TOKEN=@EngrMMOme:AAH11Q_ANx918VWvoPdVYxZNquIF-j8PmK8
ENV SOLANA_RPC_URL=https://api.mainnet-beta.solana.com

# Expose the port the app will run on
EXPOSE 8080

# Run the bot when the container launches
CMD ["python", "telegram_bot.py"]
