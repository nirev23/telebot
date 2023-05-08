VERSION: $(shell git describe --tegs --abbrev=0)-$(shell git rev-parse --short HEAD)


format:
	gofmt -s -w ./

build:
	go build -v -o telebot -ldflags "-X="github.com/nirev23/telebot/cmd.appVersion=${VERSION}"