# renovate: datasource=github-releases depName=go-task/task
TASK_VERSION=v3.24.0

TOOLING_ARCH=amd64
TOOLING_OS=$(shell uname -s | tr "[:upper:]" "[:lower:]")
DOWNLOADS_FOLDER=$$HOME/downloads

TARGETS=install-task

all: $(TARGETS)

install-task:
	mkdir -p $(DOWNLOADS_FOLDER)
	curl --location --output $(DOWNLOADS_FOLDER)/task_$(TOOLING_OS)_$(TOOLING_ARCH).tar.gz https://github.com/go-task/task/releases/download/$(TASK_VERSION)/task_$(TOOLING_OS)_$(TOOLING_ARCH).tar.gz
	tar --directory $(DOWNLOADS_FOLDER) -xzf $(DOWNLOADS_FOLDER)/task_$(TOOLING_OS)_$(TOOLING_ARCH).tar.gz task
	sudo install -o root -g root -m 0755 $(DOWNLOADS_FOLDER)/task /usr/local/bin/task-$(TASK_VERSION)
	sudo ln --force /usr/local/bin/task-$(TASK_VERSION) /usr/local/bin/task
	rm -Rf $(DOWNLOADS_FOLDER)/task $(DOWNLOADS_FOLDER)/task_$(TOOLING_OS)_$(TOOLING_ARCH).tar.gz
