notify ?= notify-send
open ?= xdg-open

all: build

build:
	yarn install
	stack build
	stack exec site build

clean:
	stack exec site clean

watch:
	watchexec --exts hs --restart -- $(MAKE) watch/build

watch/build:
	$(MAKE) build && $(notify) 'success' || $(notify) 'failure'
	stack exec site watch

start: open watch

open:
	$(open) 'http://127.0.0.1:25252'

browse:
	$(open) https://aiya000.github.io

POST_NAME := $$(date +'%Y-%m-%d')-$(name)

# make post name=me
post:
	mkdir "./images/posts/$(POST_NAME)"
	echo ---       >  "./posts/$(POST_NAME).md"
	echo 'title: ' >> "./posts/$(POST_NAME).md"
	echo 'tags: '  >> "./posts/$(POST_NAME).md"
	echo ---       >> "./posts/$(POST_NAME).md"

deploy: build
	./scripts/deploy.hs
