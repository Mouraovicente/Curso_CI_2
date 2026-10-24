FROM golang:1.27.3 AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /out/main .

FROM ubuntu:latest
EXPOSE 8000
WORKDIR /app
ENV HOST=localhost PORT=5432
ENV USER=root PASSWORD=root DBNAME=root
COPY --from=build /out/main main
COPY assets assets
COPY templates templates
CMD [ "./main" ]
