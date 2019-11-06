notify ?= notify-send
open ?= xdg-open

all: build

build:
	stack build && stack exec site build

clean:
	stack exec site clean

watch:
	watchexec --exts hs --restart -- $(MAKE) watch/build

watch/build:
	$(MAKE) build && $(notify) 'success' || $(notify) 'failure'
	stack exec site watch

open:
	xdg-open 'http://127.0.0.1:25252'

POST_NAME := $$(date +'%Y-%m-%d')-$(name)

# make post name=me
post:
	mkdir "./images/posts/$(POST_NAME)"
	echo ---       >  "./posts/$(POST_NAME).md"
	echo 'title: ' >> "./posts/$(POST_NAME).md"
	echo 'tags: '  >> "./posts/$(POST_NAME).md"
	echo ---       >> "./posts/$(POST_NAME).md"

deploy:
	./scripts/deploy.hs

browse:
	$(open) https://aiya000.github.io
