# Use a lightweight Go image for building
FROM golang:1.23.2-alpine AS builder

# Install necessary tools in the builder image
RUN apk add --no-cache git

# Set the working directory inside the container
WORKDIR /app

# Copy Go module files first and download dependencies
COPY go.mod go.sum ./
RUN go mod download
# COPY .env .env

# Copy the rest of the application files
COPY . .

# Build the application
RUN go build -o nextinbox

# Start a new stage with a minimal image
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the built binary file from the builder stage
COPY --from=builder /app/nextinbox .
COPY doc.html doc.html

# Expose the port your app listens on
EXPOSE 7860

# Command to run the application
CMD ["./nextinbox"]
