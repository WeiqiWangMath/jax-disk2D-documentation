Project Structure
=================

The package is organized into several main components:

* ``jaxdisk2D/physics_informed_training/``: Core PINN training modules implementing time-marching, periodic layers, and physics constraints
* ``fargo_utils/``: Utilities for setting up and running FARGO3D simulations
* ``fargo_data_process/``: Tools for processing FARGO3D output data (used for validation, not training)
* ``guild.yml``: Guild AI workflow definitions for reproducible experiments
