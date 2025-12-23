Downloading Pre-computed Data
==============================

To help you get started quickly, we provide pre-computed FARGO3D simulation data and trained PINN models on Hugging Face. You can download these datasets instead of running lengthy simulations or training from scratch.

**Hugging Face Dataset**: `WeiqiWangMath/jax-disk2D-runs <https://huggingface.co/datasets/WeiqiWangMath/jax-disk2D-runs>`_

Available Datasets
------------------

The following pre-computed runs are available for download. For detailed parameter explanations, see :doc:`default_parameters`.

FARGO3D Simulation Data
~~~~~~~~~~~~~~~~~~~~~~~

These are converted FARGO3D simulation outputs in NetCDF format, ready for PINN training:

* ``0a0ae0abd3ad4e758a35b28b0616686a`` — PlanetMass 1e-3, AspectRatio 0.1
* ``ebf661d56a3e4c6d975ed69d4ebeca1b`` — PlanetMass 1e-3, AspectRatio 0.05 (default parameters)
* ``fd216a503a274181987e24636f40f154`` — PlanetMass 1e-4, AspectRatio 0.05

PINN Training Runs
~~~~~~~~~~~~~~~~~~

Pre-trained PINN models with training logs and results:

* ``333a2fb279754acfb79edf8c581f51ab`` — Sample PINN training run based on ``ebf661d56a3e4c6d975ed69d4ebeca1b``. Uses default training parameters (9×32 MLP, ``stan`` activation, 6.4M epochs). Includes TensorBoard logs.

Downloading Data
----------------

**Important Notes:**

* **Storage space**: Each run can be several GB in size. Download only what you need using the ``--folders`` option.
* **Guild AI integration**: Make sure the downloaded data is in your ``$GUILD_HOME`` directory or accessible to Guild AI.

Prerequisites
~~~~~~~~~~~~~

First, activate your Python virtual environment (see :doc:`installation` for setup):

.. code-block:: bash

   source <workspace-dir>/jax-disk2D-venv/bin/activate

Then install the Hugging Face Hub library:

.. code-block:: bash

   pip install huggingface_hub

Download All Data
~~~~~~~~~~~~~~~~~

To download all available runs:

.. code-block:: bash

   python download_data.py

This downloads everything to ``./jax-disk2D-runs/`` by default.

Download Specific Runs
~~~~~~~~~~~~~~~~~~~~~~~

To download only specific runs, use the ``--folders`` option with the run IDs:

**Download a single FARGO3D run:**

.. code-block:: bash

   python download_data.py --folders ebf661d56a3e4c6d975ed69d4ebeca1b

**Download multiple runs:**

.. code-block:: bash

   python download_data.py --folders ebf661d56a3e4c6d975ed69d4ebeca1b 333a2fb279754acfb79edf8c581f51ab

**Download to a custom directory:**

.. code-block:: bash

   python download_data.py --local-dir /path/to/custom/directory --folders ebf661d56a3e4c6d975ed69d4ebeca1b

Command Line Options
~~~~~~~~~~~~~~~~~~~~

The ``download_data.py`` script accepts the following options:

* ``--repo-id``: Hugging Face dataset repository ID (default: ``WeiqiWangMath/jax-disk2D-runs``)
* ``--local-dir``: Local directory to save downloaded data (default: ``./jax-disk2D-runs``)
* ``--folders``: Space-separated list of run IDs to download (downloads all if not specified)

Using Downloaded Data
---------------------

Using FARGO3D Data for Training
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After downloading a FARGO3D run, you can use it directly for PINN training. The run ID corresponds to the ``to_xarray`` job ID:

.. code-block:: bash

   guild run pinn:train @parameters.yml fargo:to_xarray=ebf661d56a3e4c6d975ed69d4ebeca1b

Examining Pre-trained Models
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Downloaded PINN training runs include:

* **Model checkpoints**: Saved neural network weights at various training stages
* **TensorBoard logs**: Training metrics and loss curves in the ``runs/`` subdirectory
* **Configuration files**: Training parameters and setup details
* **Output visualizations**: Generated plots and movies (if available)

Next Steps
----------

After downloading data:

* Use FARGO3D runs to train your own PINN models (see :doc:`getting_started`)
* Examine pre-trained models to understand training dynamics
* Use as reference data for validation
