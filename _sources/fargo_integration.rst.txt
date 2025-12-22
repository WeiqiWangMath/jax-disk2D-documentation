FARGO3D Integration
===================

jax-disk2D integrates with FARGO3D for generating training data. This section covers how to set up, compile, and run FARGO3D simulations.

Getting FARGO3D
---------------

Download the FARGO3D sources using Guild AI:

.. code-block:: bash

   guild run fargo:get_fargo

This will clone the FARGO3D repository into a ``fargo3d/`` directory.

Compiling FARGO3D
-----------------

Compile FARGO3D with a specific configuration:

.. code-block:: bash

   guild run fargo:setup @fargo_make.yml

GPU Compilation
~~~~~~~~~~~~~~~

To run simulations on GPU(s), you need to:

1. Compile on a **GPU node** with CUDA loaded
2. Set ``GPU=1`` in your configuration
3. Ensure CUDA modules are loaded

Example for Compute Canada:

.. code-block:: bash

   module load cuda
   guild run fargo:setup @fargo_make.yml GPU=1

Running Simulations
-------------------

Default fargo2 Setup
~~~~~~~~~~~~~~~~~~~~

Run a default fargo2 simulation:

.. code-block:: bash

   guild run fargo:run @fargo2_run.yml

Customizing Parameters
~~~~~~~~~~~~~~~~~~~~~~

You can override parameters when running:

.. code-block:: bash

   guild run fargo:run @fargo2_run.yml Ntot=100

This changes the number of orbits to 5 (assuming default time step).

Configuration Files
-------------------

FARGO3D uses several configuration files:

* ``fargo2_run.yml``: Default fargo2 setup configuration
* ``fargo_run.yml``: Alternative setup configuration
* ``fargo_make.yml``: Compilation configuration

Converting Output
-----------------

Convert FARGO3D output to xarray format for PINN training:

.. code-block:: bash

   guild run fargo:to_xarray run=<run_job_id>

This creates NetCDF files (``.nc``) and NumPy arrays (``.npz``) that can be used for training.

Output Files
~~~~~~~~~~~~

The conversion process creates:

* ``test_data.npz``: Training data in NumPy format
* ``test_dens.nc``: Density field in NetCDF format
* ``test_vx.nc``: Radial velocity in NetCDF format
* ``test_vy.nc``: Azimuthal velocity in NetCDF format

These files are automatically linked to PINN training operations.

