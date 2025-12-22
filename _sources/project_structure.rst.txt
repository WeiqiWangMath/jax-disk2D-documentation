Project Structure
=================

This page provides an overview of the jax-disk2D repository structure and organization.

Repository Tree
---------------

The jax-disk2D package is organized as follows:

.. code-block:: text

   jax-disk2D/
   ├── jaxdisk2D/                      # Main package
   │   └── physics_informed_training/  # PINN training modules
   │       ├── jaxphyinf/              # Core PINN framework
   │       │   ├── neural_networks.py  # MLP architectures
   │       │   ├── activation.py       # Custom activation functions
   │       │   ├── initialization.py   # Weight initialization
   │       │   ├── adaptive_weights.py # Loss weight balancing
   │       │   ├── gradients.py        # Gradient computation
   │       │   ├── constraints.py      # Physics constraints
   │       │   ├── io/                 # I/O utilities
   │       │   └── utils/              # Helper functions
   │       ├── train.py                # Main training script
   │       ├── run_time_marching.py    # Time-marching training
   │       ├── model.py                # PINN model definitions
   │       ├── pde.py                  # PDE residual computation
   │       ├── boundary_condition.py   # Boundary conditions
   │       ├── initial_condition.py    # Initial conditions
   │       ├── constraints.py          # Constraint definitions
   │       ├── sample.py               # Collocation point sampling
   │       ├── draw_2d.py              # Visualization tools
   │       ├── config.py               # Configuration management
   │       └── postprocess/            # Post-processing utilities
   │           ├── animation.py        # Animation generation
   │           ├── data.py             # Data processing
   │           └── tensorboard_utils.py # TensorBoard logging
   │
   ├── fargo_utils/                    # FARGO3D integration
   │   ├── fargo_run.py                # FARGO3D runner
   │   ├── fargo_setups.py             # Setup configurations
   │   ├── boundary.py                 # Boundary conditions
   │   ├── ic.py                       # Initial conditions
   │   ├── planet.py                   # Planet configurations
   │   ├── opt.py                      # Option file handling
   │   ├── par.py                      # Parameter file handling
   │   └── setup_base/                 # Base setup templates
   │
   ├── fargo_data_process/             # FARGO3D data processing
   │   ├── fargo_outputs2xarray.py     # Output conversion
   │   ├── fargoData.py                # Data loading
   │   ├── config.py                   # Configuration
   │   └── utils.py                    # Utilities
   │
   ├── guild.yml                       # Guild AI workflow definitions
   ├── parameters.yml                  # Default training parameters
   ├── requirements.txt                # Python dependencies
   ├── fargo_make.yml                  # FARGO3D build configuration
   ├── fargo2_run.yml                  # FARGO3D fargo2 setup
   ├── download_data.py                # Hugging Face data downloader
   ├── run_cpu.sh                      # CPU training script
   └── run_gpu.sh                      # GPU training script

Main Components
---------------

jaxdisk2D Package
~~~~~~~~~~~~~~~~~

The core package implementing Physics-Informed Neural Networks for disk hydrodynamics. This package contains all the machinery for training PINNs to solve the time-dependent, two-dimensional disk equations without requiring precomputed simulation data.

**jaxdisk2D/physics_informed_training/**

Core PINN training modules that implement the complete training pipeline:

* ``train.py``: Main training loop implementing the complete optimization workflow. Handles loss computation from multiple sources (PDE residuals, boundary conditions, initial conditions), gradient aggregation, and parameter updates using Adam optimizer with learning rate scheduling. Manages checkpointing, logging to TensorBoard, and periodic model saving.

* ``run_time_marching.py``: Implements the time-marching strategy for stable long-term evolution. Decomposes the full time domain into overlapping windows, training separate neural networks for each window. This approach prevents error accumulation and enables modeling of extended timescales that would be unstable with a single global network.

* ``model.py``: Neural network model definitions featuring periodic input layers for azimuthal coordinate, hard enforcement of initial conditions through time-suppression functions, and output scaling to match physical magnitudes. Integrates the various components (neural networks, constraints, physics equations) into a unified model.

* ``pde.py``: Computes PDE residuals for the governing equations of disk hydrodynamics: continuity equation (mass conservation) and momentum equations in radial and azimuthal directions. Implements automatic differentiation to compute spatial and temporal derivatives of the neural network outputs, which are then used to evaluate how well the solution satisfies the PDEs.

* ``sample.py``: Implements collocation point sampling strategies for evaluating PDE residuals, boundary conditions, and initial conditions. Supports uniform random sampling, Latin hypercube sampling, and stratified sampling. Handles resampling at regular intervals during training to ensure good coverage of the spatiotemporal domain.

* ``draw_2d.py``: Comprehensive 2D visualization and animation generation tools. Creates polar and Cartesian plots of solution fields (density, velocities), generates comparison plots with FARGO3D reference data, computes error metrics, and produces animations showing time evolution. Outputs in both PNG and MP4 formats for publications and presentations.

* ``config.py``: Configuration management system handling parameter loading, validation, and default values. Parses YAML configuration files, merges with command-line arguments, and provides type-safe access to training hyperparameters, network architecture settings, and physical parameters.

**jaxdisk2D/physics_informed_training/jaxphyinf/**

Low-level PINN framework extracted for reusability and modularity. This subpackage provides general-purpose tools that can be used for other PINN applications beyond disk hydrodynamics:

* ``neural_networks.py``: Multi-layer perceptron (MLP) implementations with various architectural choices. Supports different activation functions, normalization schemes, and output transformations. Implements periodic encoding for angular coordinates and Fourier feature mappings for improved high-frequency learning. Provides both fully-connected and residual network architectures.

* ``activation.py``: Custom activation functions optimized for physics-informed learning. Includes the Stan activation (smooth periodic function), sinusoidal activation (excellent for periodic problems), and adaptive activation functions that learn optimal shapes during training. Each activation is implemented with efficient JAX operations for GPU acceleration.

* ``initialization.py``: Weight initialization schemes critical for successful PINN training. Implements Glorot (Xavier) initialization, LeCun initialization, He initialization, and specialized sine initialization for periodic activation functions. Proper initialization helps avoid vanishing/exploding gradients and improves convergence speed.

* ``adaptive_weights.py``: Adaptive loss weight balancing methods to handle the multi-objective nature of PINN training. Implements Neural Tangent Kernel (NTK) based weighting, initial loss weighting, and gradient-based methods. These techniques prevent any single loss term from dominating and ensure balanced learning across all physics constraints.

* ``gradients.py``: Gradient computation and aggregation methods for multi-loss optimization. Implements various strategies for combining gradients from different loss terms (PDE residuals, boundary conditions, initial conditions, data). Supports sum aggregation, weighted sum, and sophisticated methods like gradient surgery to prevent conflicting gradient directions.

* ``constraints.py``: Soft constraint enforcement mechanisms for incorporating boundary conditions, initial conditions, and other physical constraints into the loss function. Provides penalty-based methods and projection-based methods. Includes tools for time-varying constraints and spatially-varying constraints.

* ``io/``: Input/output utilities for saving and loading trained models, checkpoints, and training state. Implements efficient serialization of JAX PyTrees using msgpack and pickle. Handles checkpoint management with automatic cleanup of old checkpoints and recovery from interrupted training.

* ``utils/``: Helper functions and utilities including array operations (reshaping, indexing, broadcasting), PyTree operations (flattening, mapping, filtering), vectorization tools for efficient batch processing, and wrapper functions for common JAX patterns.

FARGO3D Integration
~~~~~~~~~~~~~~~~~~~

Integration with FARGO3D provides reference solutions for validation and comparison. While PINNs do not require training data, FARGO3D simulations serve as ground truth for evaluating accuracy and demonstrating that PINNs can reproduce results from traditional numerical methods.

**fargo_utils/**

Comprehensive utilities for setting up, configuring, and running FARGO3D simulations:

* ``fargo_run.py``: Python interface to FARGO3D providing high-level control over simulation execution. Handles compilation with appropriate flags, manages input/output directories, monitors simulation progress, and captures stdout/stderr. Supports both CPU and GPU execution modes and provides restart capabilities for interrupted simulations.

* ``fargo_setups.py``: Library of predefined simulation setups covering common disk scenarios. Includes the fargo2 setup (planet-disk interaction), planetary migration scenarios, multi-planet systems, and various disk configurations. Each setup specifies grid resolution, physical parameters, planet properties, and output cadence. Users can extend with custom setups by following the established patterns.

* ``boundary.py``: Sophisticated boundary condition handling matching FARGO3D's capabilities. Implements various boundary types: open boundaries (waves exit freely), reflecting boundaries (waves bounce back), periodic boundaries (wrap-around), and damping boundaries (wave-killing zones). Generates appropriate boundary condition files that FARGO3D reads during initialization.

* ``ic.py``: Initial condition generation for disk simulations. Creates physically realistic initial states including power-law surface density profiles, Keplerian velocity fields, thermal equilibrium temperature distributions, and perturbations for testing wave propagation. Supports both analytic formulas and numerical relaxation to equilibrium states.

* ``planet.py``: Planet and companion configuration system. Defines orbital parameters (semi-major axis, eccentricity, inclination), physical properties (mass, radius, accretion rate), and disk interaction parameters (smoothing length, torque prescription). Handles multi-planet systems with gravitational interactions and migration tracking.

* ``opt.py``: Option file parsing and generation. FARGO3D uses .opt files to specify which physics modules to enable (viscosity, self-gravity, MHD, etc.). This module reads and writes .opt files, validates options, and ensures consistency between different setup components.

* ``par.py``: Parameter file handling for FARGO3D's .par format. These ASCII files contain simulation parameters like grid sizes, physical constants, output settings, and runtime controls. Provides convenient Python API for reading, modifying, and writing parameter files programmatically.

* ``setup_base/``: Base templates and reference files for creating new FARGO3D setups. Contains template C files for initial conditions, boundary condition specifications, default parameter files, and option files. Users copy and modify these templates when defining custom disk configurations or physical processes.

**fargo_data_process/**

Tools for processing FARGO3D output data, used for validation and comparison with PINN solutions. These tools do not participate in PINN training (which is data-free) but enable quantitative accuracy assessment:

* ``fargo_outputs2xarray.py``: Converts FARGO3D's native binary output format to xarray datasets. FARGO3D writes fields as separate binary files for each output snapshot. This module reads these files, assembles them into coherent datasets with proper coordinates (radius, azimuth, time), applies unit conversions, and saves to NetCDF format for easier analysis and visualization.

* ``fargoData.py``: Comprehensive data loading and manipulation interface. Provides high-level access to FARGO3D outputs including lazy loading for large datasets, on-the-fly unit conversions, spatial interpolation to arbitrary coordinates, temporal interpolation between snapshots, and computation of derived quantities (vorticity, angular momentum, torque densities).

* ``config.py``: Configuration management for data processing pipeline. Stores paths to FARGO3D outputs, coordinate system specifications, unit definitions, and output preferences. Ensures consistent data handling across different analysis scripts and workflows.

* ``utils.py``: Helper functions for common data processing tasks including grid operations (averaging, differentiation, integration), coordinate transformations (polar to Cartesian), resampling to different grid resolutions, and statistical analysis (mean, variance, Fourier analysis).

Configuration Files
~~~~~~~~~~~~~~~~~~~

These files control various aspects of the workflow from FARGO3D simulations to PINN training to experiment management:

* ``guild.yml``: Guild AI workflow definitions enabling reproducible machine learning experiments. Defines operations (run FARGO3D, convert data, train PINN, generate visualizations) with their dependencies, flags (hyperparameters), and required files. Guild AI tracks all runs, logs metrics, manages artifacts, and enables hyperparameter sweeps. Essential for systematic experimentation and result comparison.

* ``parameters.yml``: Default PINN training parameters representing a high-performance configuration optimized for accurate long-term disk evolution. Includes network architecture (layer sizes, activation functions), training settings (learning rate, decay schedule, number of epochs), sampling strategy (collocation points, resampling frequency), loss weighting methods, and physical parameters (Reynolds number, disk aspect ratio). Users typically start with these defaults and adjust for specific problems.

* ``requirements.txt``: Python package dependencies with version specifications ensuring reproducible environments. Includes core dependencies (JAX, numpy, scipy), visualization libraries (matplotlib, ffmpeg), data processing tools (xarray, netCDF4), workflow management (guildai), configuration parsing (PyYAML), and progress monitoring (tqdm). Installing these dependencies creates a complete working environment.

* ``fargo_make.yml``: FARGO3D compilation configuration for Guild AI integration. Specifies compiler flags (optimization level, GPU support, debug symbols), build directories, setup selection, and parallel compilation settings. Enables automated compilation as part of the workflow ensuring consistency between different machines and users.

* ``fargo2_run.yml``: Specific configuration for the fargo2 setup (planet-disk interaction scenario). Includes planet mass, orbital radius, disk properties, simulation duration covering multiple orbits, and output frequency capturing wave dynamics. This benchmark problem demonstrates spiral density wave excitation and gap formation.

Execution Scripts
~~~~~~~~~~~~~~~~~

Shell scripts and utilities for common execution scenarios:

* ``run_cpu.sh``: Launches PINN training on CPU with appropriate thread settings and memory limits. Useful for debugging, small-scale tests, and environments without GPU access.

* ``run_gpu.sh``: Launches PINN training on GPU with CUDA configuration and memory optimization flags. Provides significant speedup (10-100x) compared to CPU execution for typical problem sizes.

* ``download_data.py``: Downloads precomputed datasets and trained models from Hugging Face Hub. Provides quick access to reference solutions and pretrained networks without running lengthy FARGO3D simulations or PINN training sessions. Includes resume capabilities for interrupted downloads.
