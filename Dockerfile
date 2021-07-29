FROM golang:1.16-alpine as builder
RUN apk update --no-cache 
RUN apk upgrade --no-cache

ENV GO111MODULE=on
WORKDIR /app

COPY go.mod go.sum ./
COPY *.go ./
RUN go build -o golang-test .


######## Start a new stage from scratch #######
FROM golang:1.16-alpine
WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/golang-test .
EXPOSE 8000

# Run as a user of least privilege
RUN addgroup -S dockertest && adduser -S dockertest -G dockertest
RUN chown -R dockertest:dockertest .
USER dockertest

ENTRYPOINT ["./golang-test"]
# CMD [ "./golang-test" ]
