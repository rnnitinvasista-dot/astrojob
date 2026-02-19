# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies for swisseph
RUN apt-get update && apt-get install -y \
    gcc \
    make \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container at /app
# (This is now synced to the root)
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project into the container
COPY . .

# Expose port 8000
EXPOSE 8000

# Run the application
# We use --pythonpath to ensure gunicorn finds main.py and nadi_core.py inside the backend folder
CMD gunicorn --pythonpath backend main:app -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT
