PINN Training
============

This section covers advanced training options for Physics-Informed Neural Networks (PINNs) with jax-disk2D. For the basic workflow of training a PINN model, see the :doc:`getting_started` guide.

Quick Summary
-------------

Training a PINN involves:

.. code-block:: bash

   guild run pinn:train @parameters.yml fargo:to_xarray=<to_xarray_job_id>

The training process loads converted FARGO3D data, initializes a neural network, and trains it to satisfy physics constraints (PDE residuals) without requiring training data. The network learns to solve the hydrodynamics equations directly from the physical laws encoded in the loss function.

Training Parameters
-------------------

Training is configured through ``parameters.yml``. The default configuration represents a high-performance setup optimized for accurate long-term evolution. All parameters are documented below with their default values.

Network Architecture Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **layer_size** (``32,32,32,32,32,32,32,32,32``): Hidden layer sizes for the multi-layer perceptron (MLP). The default configuration uses 9 hidden layers with 32 neurons each. This provides sufficient capacity for learning complex spatiotemporal dynamics.

* **activation** (``stan``): Activation function for the neural network. Options include ``sin``, ``tanh``, ``swish``, and ``stan``. The ``stan`` activation is a smooth, periodic activation function well-suited for physical systems.

* **initializer** (``glorot_normal``): Weight initialization method. Options include ``glorot_uniform``, ``glorot_normal``, ``lecun_uniform``, ``lecun_normal``, ``he_uniform``, ``he_normal``, and ``sine_uniform``. Glorot (Xavier) normal initialization is the default. (TODO: Check if these options are still supported)

* **enable_x64** (``no``): Whether to use 64-bit floating point precision in JAX. Set to ``yes`` for higher precision but slower computation. Default is ``no`` (32-bit).

Training Configuration Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **num_epochs** (``6400000``): Total number of training iterations. The high-performance default uses 6.4 million epochs for thorough convergence.

* **lr** (``0.001``): Learning rate for the Adam optimizer. Controls the step size during gradient descent.

* **decay_rate** (``0.9``): Learning rate decay rate. The learning rate is multiplied by this factor every ``transition_steps`` iterations.

* **transition_steps** (``5000``): Number of steps per learning rate decay period. Used together with ``decay_rate`` to implement exponential learning rate decay.

* **random_seed** (``123``): Random seed for reproducibility. Ensures consistent random number generation for sampling and initialization.

Sampling Parameters
~~~~~~~~~~~~~~~~~~~

* **num_domain** (``10000``): Number of collocation points sampled in the spatiotemporal domain for evaluating PDE residuals. Higher values provide better coverage but increase computational cost.

* **num_boundary** (``0``): Number of training samples on the domain boundaries. Set to 0 in the default configuration as the boundary-free approach is used.

* **num_initial** (``0``): Number of training samples for the initial condition. Set to 0 when using hard initial condition enforcement (see ``ic`` parameter).

* **num_period_sample** (``10``): Period (in training steps) for resampling PDE domain collocation points. Resampling helps the network learn from different regions of the domain throughout training.

Initial and Boundary Condition Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **ic** (``hard``): Initial condition handling method. Options:
  
  * ``hard``: Applies time-suppressed exact initial condition enforcement
  * ``shift``: Adds initial condition to network outputs
  * Empty string: Disables initial condition transform

* **bc** (``ignore``): Boundary condition handling. Options:
  
  * ``ignore``: Disables boundary condition losses (boundary-free approach)
  * Empty string: Uses FARGO3D boundary condition types

* **scale_on_hardic** (``1.0``): Scale factor in the time-suppressor for hard initial conditions. Larger values mean faster release of the initial condition constraint.

Output Scaling Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~

These parameters scale the network outputs to match the physical magnitudes of the solution variables:

* **scale_on_sigma** (``0.1``): Output scaling factor for surface density (Σ)

* **scale_on_v_r** (``0.001``): Output scaling factor for radial velocity (v_r)

* **scale_on_v_theta** (``0.001``): Output scaling factor for azimuthal velocity (v_θ)

* **scale_on_t** (``1.0``): Scaling applied to the time channel in periodic input transform

Time-Marching Parameters
~~~~~~~~~~~~~~~~~~~~~~~~

* **time_folds** (``0,0.03125|(-0.00625, 0.03125)*31``): Time window configuration for time-marching training. This parameter partitions the total simulation time into overlapping windows, each with its own neural network. The format is relative [start, width] segments that sum to 1.0. The default configuration uses 32 overlapping time windows.

Loss and Gradient Computation Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **g_compute_method** (``initial_loss_weighted_sum``): Method for aggregating per-loss gradients. Options:
  
  * ``sum``: Simple sum of all loss gradients
  * ``ntk_weighted_sum``: Neural Tangent Kernel (NTK) weighted sum
  * ``initial_loss_weighted_sum``: Weighted by initial loss values (default)

* **number_period_update_weights** (``100``): Period (in training steps) to update adaptive loss weights when using NTK or initial loss weighting methods.

Logging and Checkpointing Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **num_period_log** (``100``): Period (in training steps) for logging loss values to TensorBoard.

* **num_period_log_scaling_factors** (``100``): Period for logging raw output magnitudes. Set to 0 to disable.

* **num_period_save_models** (``10000``): Period (in training steps) for saving intermediate model checkpoints.

* **log_stats_g** (``no``): Whether to log gradient statistics to TensorBoard.

* **save** (``yes``): Whether to write models, logs, and NetCDF outputs to the save directory.

* **save_dir** (``.``): Output directory for checkpoints, logs, and generated artifacts.

FARGO3D Integration Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **fargo_setups** (``fargo2``): FARGO3D setup name used to load physical parameters and configuration.

* **fargo_source_dir** (``fargo3d``): Path to FARGO3D project or outputs directory containing configuration files and test data.

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
               <source src="../../movies/0bb155ba/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
       </div>
       <div class="video-item">
           <video controls>
               <source src="../../movies/1f1dc333/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
       </div>
       <div class="video-item">
           <video controls>
               <source src="../../movies/3c51e831/dens-predict.mp4" type="video/mp4">
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

