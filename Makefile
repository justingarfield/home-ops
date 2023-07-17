# renovate: datasource=github-releases depName=go-task/task
TASK_VERSION=v3.24.0
DOWNLOADS_FOLDER=$$HOME/downloads

ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH=amd64
        ;;
    aarch64)
        ARCH=arm64
        ;;
esac
OS=$(shell uname -s | tr "[:upper:]" "[:lower:]")

TARGETS=install-task

all: $(TARGETS)

install-task:
	mkdir -p $(DOWNLOADS_FOLDER)
	curl --location --output $(DOWNLOADS_FOLDER)/task_$(TOOLING_OS)_$(TOOLING_ARCH).tar.gz https://github.com/go-task/task/releases/download/$(TASK_VERSION)/task_$(OS)_$(ARCH).tar.gz
	tar --directory $(DOWNLOADS_FOLDER) -xzf $(DOWNLOADS_FOLDER)/task_$(TOOLING_OS)_$(TOOLING_ARCH).tar.gz task
	sudo install -o root -g root -m 0755 $(DOWNLOADS_FOLDER)/task /usr/local/bin/task-$(TASK_VERSION)
	sudo ln --force /usr/local/bin/task-$(TASK_VERSION) /usr/local/bin/task
	rm -Rf $(DOWNLOADS_FOLDER)/task $(DOWNLOADS_FOLDER)/task_$(TOOLING_OS)_$(TOOLING_ARCH).tar.gz
