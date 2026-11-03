#!/usr/bin/env bash
set -e

REPO_NAME="Creators-Theorem"
DESCRIPTION="Теорема Творца / Creator’s Theorem — multilingual philosophical-scientific cycle"

echo "=========================================="
echo "  Creator’s Theorem → GitHub"
echo "=========================================="
echo

# Check if gh is available and authenticated
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    echo "✓ GitHub CLI authenticated"
    USE_GH=true
  else
    echo "⚠ gh is installed but not authenticated"
    USE_GH=false
  fi
else
  echo "⚠ gh not found, will use plain git"
  USE_GH=false
fi

# Initialize git if needed
if [ ! -d .git ]; then
  echo "→ Initializing git repository..."
  git init
  git branch -M main
fi

# Add everything
echo "→ Adding files..."
git add .

# Commit
if git diff --cached --quiet; then
  echo "→ Nothing new to commit"
else
  echo "→ Creating commit..."
  git commit -m "Initial release: Creator’s Theorem cycle (RU complete, multilingual structure)"
fi

# Create remote repo and push
if [ "$USE_GH" = true ]; then
  echo "→ Creating GitHub repository with gh..."
  # Check if repo already exists
  if gh repo view "$REPO_NAME" >/dev/null 2>&1; then
    echo "  Repository already exists, using it..."
  else
    gh repo create "$REPO_NAME" --public --description "$DESCRIPTION" --source=. --remote=origin
  fi
  
  echo "→ Pushing to GitHub..."
  git push -u origin main
else
  echo
  echo "GitHub CLI (gh) is not available or not authenticated."
  echo "Please run one of the following manually:"
  echo
  echo "  1. Authenticate gh:"
  echo "       gh auth login"
  echo
  echo "  2. Or create the repo manually on github.com and then:"
  echo "       git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
  echo "       git push -u origin main"
  echo
  exit 1
fi

echo
echo "=========================================="
echo "  Done!"
echo "  Repository should be available at:"
echo "  https://github.com/$(gh api user --jq .login 2>/dev/null || echo YOUR_USERNAME)/$REPO_NAME"
echo "=========================================="
