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
   ├── fargo_run.yml                   # FARGO3D run configuration
   ├── fargo2_run.yml                  # FARGO3D fargo2 setup
   ├── download_data.py                # Hugging Face data downloader
   ├── run_cpu.sh                      # CPU training script
   ├── run_gpu.sh                      # GPU training script
   └── submit.sh                       # HPC submission script

Main Components
---------------

jaxdisk2D Package
~~~~~~~~~~~~~~~~~

The core package implementing Physics-Informed Neural Networks for disk hydrodynamics.

**jaxdisk2D/physics_informed_training/**

Core PINN training modules:

* ``train.py``: Main training loop with loss computation and optimization
* ``run_time_marching.py``: Time-marching strategy for long-term evolution
* ``model.py``: Neural network model definitions with periodic layers and hard initial conditions
* ``pde.py``: PDE residual computation for continuity and momentum equations
* ``sample.py``: Collocation point sampling strategies
* ``draw_2d.py``: 2D visualization and animation generation

**jaxdisk2D/physics_informed_training/jaxphyinf/**

Low-level PINN framework (extracted for reusability):

* ``neural_networks.py``: Multi-layer perceptron implementations
* ``activation.py``: Custom activation functions (Stan, Sin, etc.)
* ``initialization.py``: Weight initialization schemes
* ``adaptive_weights.py``: Adaptive loss weight balancing (NTK, initial loss)
* ``gradients.py``: Gradient computation and aggregation methods
* ``constraints.py``: Soft constraint enforcement

FARGO3D Integration
~~~~~~~~~~~~~~~~~~~

**fargo_utils/**

Utilities for setting up and running FARGO3D simulations:

* ``fargo_run.py``: Python interface to FARGO3D
* ``fargo_setups.py``: Predefined simulation setups
* ``boundary.py``: Boundary condition handling
* ``ic.py``: Initial condition generation
* ``planet.py``: Planet/companion configuration

**fargo_data_process/**

Tools for processing FARGO3D output data (used for validation, not training):

* ``fargo_outputs2xarray.py``: Convert FARGO3D outputs to xarray format
* ``fargoData.py``: Load and manipulate FARGO3D data
* ``utils.py``: Helper functions for data processing

Configuration Files
~~~~~~~~~~~~~~~~~~~

* ``guild.yml``: Guild AI workflow definitions for reproducible experiments
* ``parameters.yml``: Default PINN training parameters
* ``requirements.txt``: Python package dependencies
* ``fargo_make.yml``: FARGO3D compilation configuration
* ``fargo_run.yml``: FARGO3D simulation configuration
* ``fargo2_run.yml``: Specific configuration for fargo2 setup
