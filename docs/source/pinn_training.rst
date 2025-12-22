PINN Training
============

This section covers training Physics-Informed Neural Networks (PINNs) with jax-disk2D.

Basic Training
--------------

Train a PINN model using FARGO3D output data:

.. code-block:: bash

   guild run pinn:train @parameters.yml fargo:to_xarray=<to_xarray_job_id>

The training process will:

* Load the converted FARGO3D data
* Initialize a neural network
* Train the network to satisfy both data constraints and physics constraints
* Save checkpoints and TensorBoard logs

Training Parameters
-------------------

Training is configured through ``parameters.yml``. Key parameters include:

* Network architecture (width, depth, activation functions)
* Training iterations
* Learning rate and optimizer settings
* Sampling strategies for PDE residuals
* Weight balancing for different loss terms

Visualization
-------------

2D Movies
~~~~~~~~~

Generate 2D movies of the predictions:

.. code-block:: bash

   guild run pinn:draw_2d pinn:train=<train_job_id>

This creates animated visualizations comparing the PINN predictions with the FARGO3D data.

Synchronized Video Comparison
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following shows three synchronized videos of density predictions from different runs:

.. raw:: html

   <div class="video-group video-group-3">
       <div class="video-item">
           <video controls>
               <source src="movies/0bb155ba/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/1f1dc333/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/3c51e831/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
       </div>
   </div>

All three videos will play, pause, and seek together when you interact with any video in the group.

Loss and Metrics
~~~~~~~~~~~~~~~~

Plot training loss and other metrics:

.. code-block:: bash

   guild run pinn:plot_tb_summary pinn:train=<train_job_id>

Check the figures in ``$GUILD_HOME/runs/<train_job_id>/runs/...``

GPU Training
------------

For GPU training, first start the training job:

.. code-block:: bash

   guild run pinn:train @parameters.yml fargo:to_xarray=<to_xarray_job_id>

Then submit it to a GPU node using SLURM:

.. code-block:: bash

   sbatch --time=40:00 \
          --mail-user=JAX_DISK2D_MAIL_USER \
          --mail-type=ALL \
          --account=<account> \
          --gres=gpu:1 \
          --mem=64G \
          run_gpu.sh <run_job_id>

Replace ``<run_job_id>`` with the Guild run ID from the previous command.

Training Components
-------------------

The PINN training involves several key components:

* **Neural Network**: Multi-layer perceptron (MLP) that maps coordinates to physical fields
* **PDE Residuals**: Loss terms enforcing the hydrodynamics equations
* **Boundary Conditions**: Constraints at domain boundaries
* **Initial Conditions**: Constraints at the initial time
* **Data Loss**: Matching the FARGO3D simulation data

See :doc:`api_reference` for detailed API documentation.

