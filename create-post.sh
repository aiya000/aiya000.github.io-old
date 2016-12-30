#!/bin/sh

title="$1"
localeditor="$2"

# Example: "2016-12-30-example_name"
postname="$(date +'%Y-%m-%d')-${title}"

# Create image dir for current post
if [ ! -d "./images/posts/${postname}" ] ; then
	mkdir "./images/posts/${postname}"
fi

# Open editor
$localeditor "./posts/${postname}.md"
