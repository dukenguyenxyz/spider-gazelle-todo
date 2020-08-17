FROM crystallang/crystal:latest-alpine
ADD . /src
WORKDIR /src

# Add trusted CAs for communicating with external services
RUN apk update && apk add --no-cache ca-certificates tzdata && update-ca-certificates

# Create a non-privileged user
# defaults are appuser:10001
ARG IMAGE_UID="10001"
ENV UID=$IMAGE_UID
ENV USER=appuser

# Use an unprivileged user.
USER appuser:appuser

# Run the app binding on port 8080
EXPOSE 8080
ENTRYPOINT ["crystal", "spec", "--error-trace", "-v"]
