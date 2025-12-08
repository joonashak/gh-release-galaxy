#!/bin/bash

set -e

GALAXY_FILE="galaxy.yml"

# Extract current version from galaxy.yml
current_version=$(grep -E '^version:' "$GALAXY_FILE" | awk '{print $2}')

# If a version is provided, use it; otherwise, bump patch
if [ -n "$1" ]; then
	new_version="$1"
else
	IFS='.' read -r major minor patch <<< "$current_version"
	patch=$((patch + 1))
	new_version="${major}.${minor}.${patch}"
fi

# Update galaxy.yml with new version
sed -i.bak "s/^version: .*/version: $new_version/" "$GALAXY_FILE"
rm "$GALAXY_FILE.bak"

# Commit the change
git add "$GALAXY_FILE"
git commit -m "Bump version to $new_version"

# Create annotated tag
git tag -as "$new_version" -m "$new_version"

# Push commit and tag
git push
git push --tags
