APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=nirev23
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
IMAGE_ID=$(shell docker images -q)
#TEST=ON

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Use 'make <target>' where <target> is one of:"
	@echo ""
	@echo "  format - formats Go programs"
	@echo "  build - build docker image"
	@echo "  lint - prints out style mistakes"
	@echo "  test - testing go packages"
	@echo "  clean - delete result file"
	@echo ""


.PHONY: build
build:
	@echo "Use 'make <target>' where <target> is one of:"
	@echo ""
	@echo "  linux - build docker image for linux"
	@echo "  darwin - build docker image for darwin"
	@echo "  windows - build docker image for windows"
	@echo "  arm - build docker image for arm64"
	@echo ""

.PHONY: linux
linux: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o telebot -ldflags "-X="github.com/nirev23/telebot/cmd.appversion=${VERSION}

.PHONY: darwin
darwin: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o telebot -ldflags "-X="github.com/nirev23/telebot/cmd.appversion=${VERSION}

.PHONY: windows
windows: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o telebot -ldflags "-X="github.com/nirev23/telebot/cmd.appversion=${VERSION}

.PHONY: arm
arm: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -o telebot -ldflags "-X="github.com/nirev23/telebot/cmd.appversion=${VERSION}

format:
	gofmt -s -w ./

lint:
	golint
 
test:
	go test -v

get: 
	go get

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}

clean:
ifeq (${IMAGE_ID},)        
	@rm -rf telebot
else
	@docker rmi ${IMAGE_ID}
endif
#if image present - delete it, if not present - delete rendered app