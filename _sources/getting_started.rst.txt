Getting Started
================

This guide will walk you through a basic workflow: running a FARGO3D simulation, converting the output, and training a PINN model.

Quick Start Workflow
--------------------

1. **Get and compile FARGO3D**
2. **Run a FARGO3D simulation**
3. **Convert FARGO output to xarray format**
4. **Train a PINN model**
5. **Visualize results**

Step 1: Get FARGO3D
-------------------

Download the FARGO3D sources:

.. code-block:: bash

   guild run fargo:get_fargo

Step 2: Compile FARGO3D
-----------------------

Compile FARGO3D with a specific configuration:

.. code-block:: bash

   guild run fargo:setup @fargo_make.yml

**Note**: To run simulations on GPU, you need to compile the code with ``GPU=1`` on a **GPU** node (CUDA must be loaded).

Step 3: Run a Simulation
------------------------

Run a default fargo2 setup:

.. code-block:: bash

   guild run fargo:run @fargo2_run.yml

To change the number of orbits to 5:

.. code-block:: bash

   guild run fargo:run @fargo2_run.yml Ntot=100

Step 4: Convert FARGO Output
----------------------------

Convert the FARGO output to xarray format for PINN training:

.. code-block:: bash

   guild run fargo:to_xarray run=<run_job_id>

Replace ``<run_job_id>`` with the ID from the previous step.

Step 5: Train a PINN Model
--------------------------

Train a PINN model using the converted data:

.. code-block:: bash

   guild run pinn:train @parameters.yml fargo:to_xarray=<to_xarray_job_id>

Replace ``<to_xarray_job_id>`` with the ID from the conversion step.

Step 6: Visualize Results
-------------------------

Draw 2D movies of the results:

.. code-block:: bash

   guild run pinn:draw_2d pinn:train=<train_job_id>

Plot loss and other metrics:

.. code-block:: bash

   guild run pinn:plot_tb_summary pinn:train=<train_job_id>

Check the figures in ``$GUILD_HOME/runs/<train_job_id>/runs/...``

Next Steps
----------

* See :doc:`fargo_integration` for detailed FARGO3D usage
* See :doc:`pinn_training` for advanced PINN training options
* See :doc:`huggingface` for downloading pre-computed data from Hugging Face

