# jax-disk2D Documentation

This repository contains the documentation website for jax-disk2D, built with Sphinx.

## Building the Documentation

### Setup

1. Activate the virtual environment:
   ```bash
   source venv/bin/activate
   ```

2. Install dependencies (if not already installed):
   ```bash
   pip install sphinx sphinx-rtd-theme
   ```

### Build

Build the HTML documentation:

```bash
cd docs
make html
```

The built documentation will be in `docs/build/html/`. Open `docs/build/html/index.html` in your browser to view it.

### Clean Build

To clean previous builds:

```bash
cd docs
make clean
```

## Development

Edit the source files in `docs/source/`:

- `index.rst` - Main index page
- `introduction.rst` - Introduction
- `installation.rst` - Installation guide
- `getting_started.rst` - Quick start guide
- `fargo_integration.rst` - FARGO3D integration
- `pinn_training.rst` - PINN training guide
- `api_reference.rst` - API documentation

After editing, rebuild with `make html` to see your changes.

## Publishing to GitHub Pages

Deploy your documentation manually when you're ready to publish:

1. **Test locally first:**
   ```bash
   cd docs
   make html
   # Open docs/build/html/index.html in your browser to preview
   ```

2. **Deploy to GitHub Pages:**
   ```bash
   chmod +x deploy.sh  # Only needed the first time
   ./deploy.sh
   ```

The script will:
- Build the documentation
- Create/update a `gh-pages` branch
- Push the built files to GitHub
- Return you to your original branch

**Advantages of manual deployment:**
- ✅ Full control over when to publish
- ✅ Test locally before publishing
- ✅ Only publish stable/ready versions
- ✅ Works with any branch

### First-Time Setup

Before the first deployment, you need to enable GitHub Pages:

1. Go to your GitHub repository
2. Settings → Pages
3. Under "Source", select the `gh-pages` branch
4. Save

### Viewing Your Documentation

After deployment, your documentation will be available at:
```
https://<your-username>.github.io/jax-disk2D-documentation/
```

**Note:** It may take 1-2 minutes after deployment for the site to be live.

