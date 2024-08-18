# Use the official Python image from the Docker Hub
FROM python:3.11-slim

# Set environment variable to ensure output is sent straight to the terminal
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Copy the requirements files into the container
COPY requirements.txt requirements.dev.txt /tmp/

# Create a virtual environment, install dependencies, and remove temp files after installation
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp

# Copy the rest of the application code into the container
COPY ./app /app

# Expose the port the application will run on
EXPOSE 8000

# Add a non-root user for running the application
RUN adduser --disabled-password --no-create-home django-user

# Set the user for the container
USER django-user

# Update PATH to include the virtual environment binaries
ENV PATH="/py/bin:$PATH"
