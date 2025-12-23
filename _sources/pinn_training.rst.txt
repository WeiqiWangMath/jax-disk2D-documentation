PINN Training
============

This section covers advanced training options for Physics-Informed Neural Networks (PINNs) with jax-disk2D. For the basic workflow of training a PINN model, see the :doc:`getting_started` guide.

Quick Summary
-------------

Training a PINN involves:

.. code-block:: bash

   guild run pinn:train @parameters.yml fargo:to_xarray=<to_xarray_job_id>

The training process loads converted FARGO3D data, initializes a neural network, and trains it to satisfy physics constraints (PDE residuals) without requiring training data. The network learns to solve the hydrodynamics equations directly from the physical laws encoded in the loss function.

For detailed information about all training parameters and their default values, see the :doc:`default_parameters` page.

Visualization
-------------

2D Movies
~~~~~~~~~

Generate 2D movies of the predictions:

.. code-block:: bash

   guild run pinn:draw_2d pinn:train=<train_job_id>

This creates animated visualizations comparing the PINN predictions with the FARGO3D reference data.

Synchronized Video Comparison
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example shows three synchronized videos playing together for comparison:

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

For GPU training on HPC systems, first start the training job:

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

See :doc:`api_reference` for detailed API documentation.

