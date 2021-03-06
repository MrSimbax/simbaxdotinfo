#!/bin/bash

# Notes for myself:
# - you must have installed and configured:
#   - git
#   - hugo
#   - uglifyjs, clean-css (npm install -g uglify-js clean-css)
# - optimize new PNGs by hand using optipng -o7
# - remember to push to the source repo too before/after deploying
#
# Remember to set before running in public/ folder
# git config git-ftp.url
# git config git-ftp.user
# git config git-ftp.password
# git config git-ftp.syncroot .

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Delete public folder
cd public
git rm -r *
cd ..

# Build the website
hugo

# Go there
cd public

# Minify JS
for f in $(find -name '*.js'); do
    uglifyjs -c -m -o $f $f;
done;

# Minify CSS
for f in $(find -name '*.css'); do
    cleancss -O2 -o $f $f;
done;

# Add files to git
git add .

# Commit changes
msg="rebuilding website `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push to GitHub Pages
git push origin HEAD:master

# Upload to FTP using git-ftp
git ftp push

# Come back up to the project root
cd ..
