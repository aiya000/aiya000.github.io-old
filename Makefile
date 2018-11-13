all: build

build:
	stack build && stack exec site build

watch:
	make build && stack exec site watch

POST_NAME := $$(date +'%Y-%m-%d')-$(name)

# make post name=me
post:
	mkdir "./images/posts/$(POST_NAME)"
	echo ---       >  "./posts/$(POST_NAME).md"
	echo 'title: ' >> "./posts/$(POST_NAME).md"
	echo 'tags: '  >> "./posts/$(POST_NAME).md"
	echo ---       >> "./posts/$(POST_NAME).md"
