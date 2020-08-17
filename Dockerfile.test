FROM crystallang/crystal:latest-alpine
ADD . /src
WORKDIR /src

# Run the app binding on port 8080
EXPOSE 8080
ENTRYPOINT ["crystal", "spec", "--error-trace", "-v"]
