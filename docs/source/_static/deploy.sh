#!/bin/bash
# Manual deployment script for GitHub Pages
# This allows you to choose when to publish your documentation

set -e  # Exit on error

echo "🚀 Deploying documentation to GitHub Pages..."

# Build the documentation
echo "📦 Building documentation..."
cd docs
make clean
make html
cd ..

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Get the current branch name
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"

# Move untracked/ignored movies folder out of the way temporarily
# to prevent checkout conflicts
MOVIES_TEMP_DIR=$(mktemp -d)
if [ -d "movies" ]; then
    echo "📁 Temporarily moving movies folder..."
    mv movies "$MOVIES_TEMP_DIR/"
fi

# Stash any uncommitted changes (including untracked files like JS/CSS)
echo "💾 Saving current state..."
git stash push --include-untracked -m "Deploy stash $(date +'%Y-%m-%d %H:%M:%S')"
STASHED=true

# Check if gh-pages branch exists
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "📄 gh-pages branch exists, updating..."
    git checkout gh-pages
    git pull origin gh-pages 2>/dev/null || true
else
    echo "📄 Creating gh-pages branch..."
    git checkout --orphan gh-pages
    git rm -rf . 2>/dev/null || true
fi

# Copy built HTML files to root
echo "📋 Copying built files..."
cp -r docs/build/html/* .

# Add a .nojekyll file
touch .nojekyll

# Stage all files
git add -A

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo "ℹ️  No changes to commit. Documentation is already up to date."
else
    # Commit the changes
    echo "💾 Committing changes..."
    git commit -m "Deploy documentation (from $CURRENT_BRANCH branch) - $(date +'%Y-%m-%d %H:%M:%S')"
    
    # Push to GitHub
    echo "⬆️  Pushing to GitHub..."
    git push origin gh-pages
    echo "✅ Documentation deployed successfully!"
fi

# Return to the original branch
git checkout "$CURRENT_BRANCH"

# Restore movies folder
if [ -d "$MOVIES_TEMP_DIR/movies" ]; then
    echo "📁 Restoring movies folder..."
    rm -rf movies # remove any files that might have been checked out from gh-pages
    mv "$MOVIES_TEMP_DIR/movies" .
fi
rm -rf "$MOVIES_TEMP_DIR"

# Restore stashed changes
if [ "$STASHED" = true ]; then
    echo "📦 Restoring your original state..."
    git stash pop 2>/dev/null || true
fi

echo "✨ Done! Returned to branch: $CURRENT_BRANCH"
