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

# Get the current branch name (for commit message only)
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"

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

# Add a .nojekyll file to tell GitHub Pages not to process with Jekyll
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
    if git push origin gh-pages; then
        echo "✅ Documentation deployed successfully!"
        echo "🌐 Your site will be available at:"
        REMOTE_URL=$(git config --get remote.origin.url)
        if [[ $REMOTE_URL == *"github.com"* ]]; then
            REPO_PATH=$(echo "$REMOTE_URL" | sed -E 's|.*github.com[:/](.*)\.git|\1|' | sed 's|:|/|')
            echo "   https://${REPO_PATH%.git}"
        else
            echo "   (Check your GitHub repository settings > Pages)"
        fi
    else
        echo "❌ Failed to push to GitHub"
        echo "💡 Make sure you have:"
        echo "   1. Created the repository on GitHub"
        echo "   2. Set up the remote: git remote add origin <your-repo-url>"
        echo "   3. Pushed your main branch first: git push -u origin main"
        exit 1
    fi
fi

# Stay on gh-pages branch after deployment
echo "✨ Done! Deployment complete. Staying on gh-pages branch."
echo ""
echo "💡 Note: It may take a few minutes for GitHub Pages to update."
echo "   Check your repository settings > Pages to see the deployment status."

