#!/bin/bash

title="$1"
postname="$(date +'%Y-%m-%d')-${title}"  # Example: "2016-12-30-example_name"

# Create image dir for current post
mkdir "./images/posts/${postname}" > /dev/null 2>&1

# Open editor
cat > "./posts/${postname}.md" << EOF
---
title: 
tags: 
---
EOF
