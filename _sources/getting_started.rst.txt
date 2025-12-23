Getting Started
================

This guide will walk you through a complete workflow: running a FARGO3D simulation, converting the output, training a PINN model, and visualizing results.

**About Guild AI and Run IDs**

This project uses Guild AI for workflow management and experiment tracking. Each operation you run with ``guild run`` is assigned a unique run ID. You'll use these run IDs to link operations together (e.g., passing FARGO3D output to PINN training) and to reference specific runs for visualization or analysis.

For more information about Guild AI, see the `Guild AI Documentation <https://guildai.org/t/guild-ai-documentation/64>`_.

Quick Start Workflow
--------------------

1. **Get and compile FARGO3D**
2. **Run FARGO3D simulation and convert output**
3. **Train a PINN model**
4. **Visualize results**

FARGO3D Setup and Simulation
-----------------------------

Step 1: Get and Compile FARGO3D
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Download and compile FARGO3D sources:

.. code-block:: bash

   guild run fargo:get_fargo

.. code-block:: bash

   guild run fargo:setup @fargo_make.yml GPU=1

**Note**: Running FARGO3D on a GPU node with CUDA loaded is strongly recommended. Ensure you have loaded the required modules (e.g., ``module load cuda/12.2`` on ComputeCanada clusters).

**Configuration Files**

* ``fargo2_run.yml``: Default fargo2 setup configuration
* ``fargo_make.yml``: Compilation configuration

For detailed FARGO3D parameter documentation, see :doc:`default_parameters`.

Step 2: Run FARGO3D Simulation and Convert Output
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run a default fargo2 setup:

.. code-block:: bash

   guild run fargo:run @fargo2_run.yml

Then convert the FARGO3D output to NetCDF format for PINN training:

.. code-block:: bash

   guild run fargo:to_xarray run=<run_job_id>

Replace ``<run_job_id>`` with the ID from the FARGO run.

**Customizing Parameters**

You can override parameters when running. For example, to change the total number of output snapshots:

.. code-block:: bash

   guild run fargo:run @fargo2_run.yml Ntot=100

**Output Files**

The conversion process creates NetCDF files:

* ``test_dens.nc``: Density field
* ``test_vx.nc``: Radial velocity
* ``test_vy.nc``: Azimuthal velocity

These files are automatically linked to PINN training operations.

PINN Training and Visualization
--------------------------------

Step 3: Train a PINN Model
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Train a PINN model using the converted data:

.. code-block:: bash

   guild run pinn:train @parameters.yml fargo:to_xarray=<to_xarray_job_id>

Replace ``<to_xarray_job_id>`` with the ID from the conversion step.

For detailed information about all training parameters and their default values, see :doc:`default_parameters`.

Step 4: Visualize Results
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Generate 2D Movies**

Generate 2D movies of the PINN predictions:

.. code-block:: bash

   guild run pinn:draw_2d pinn:train=<train_job_id>

This creates animated visualizations comparing the PINN predictions with the FARGO3D reference data. Check the movies in ``$GUILD_HOME/runs/<train_job_id>/...``

**Plot Loss and Metrics**

Plot training loss and other metrics:

.. code-block:: bash

   guild run pinn:plot_tb_summary pinn:train=<train_job_id>

Check the figures in ``$GUILD_HOME/runs/<train_job_id>/runs/...``

Submitting Jobs to GPU Compute Nodes
-------------------------------------

On HPC systems like ComputeCanada clusters, you should submit computationally intensive operations to GPU compute nodes using SLURM. This is especially useful for PINN training runs, but the same approach works for other Guild operations such as FARGO3D simulations or visualization tasks.

**Submitting a Training Job (Example)**

First, start the Guild operation:

.. code-block:: bash

   guild run pinn:train @parameters.yml fargo:to_xarray=<to_xarray_job_id> --stage

Then submit it to a GPU node using SLURM:

.. code-block:: bash

   sbatch --time=40:00 --account=<account> --gres=gpu:h100:1 --mem=64G run_gpu.sh <run_job_id>

Replace ``<run_job_id>`` with the Guild run ID from the previous command, and ``<account>`` with your compute allocation.

**SLURM Parameters**

* ``--time``: Maximum walltime for the job (format: hours:minutes)
* ``--account``: Your compute allocation account
* ``--gres=gpu:h100:1``: Request one H100 GPU
* ``--mem``: Memory allocation (e.g., 64G for 64 GB)

Adjust these parameters based on your specific needs and available resources. See `<https://docs.alliancecan.ca/wiki/Running_jobs>`_ for more information on how to submit jobs to GPU compute nodes.

Next Steps
----------

* See :doc:`huggingface` to download pre-computed FARGO3D data and trained PINN models
* See :doc:`default_parameters` for detailed parameter documentation
* See :doc:`project_structure` for repository organization

