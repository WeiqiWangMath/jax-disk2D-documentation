Default Parameters
==================

This page documents the default parameters for FARGO3D simulations and PINN training configurations.

FARGO3D Parameters
------------------

These parameters configure FARGO3D simulations for generating reference solutions and validation data. The parameters below are taken from the ``fargo2_run.yml`` configuration file.

For comprehensive documentation on FARGO3D parameters and their usage, please refer to the `FARGO3D User Guide <https://fargo3d.github.io/documentation/index.html>`_.

Disk Parameters
~~~~~~~~~~~~~~~

* **AspectRatio** (``0.05``): Disk aspect ratio H/R, where H is the disk scale height and R is the radial distance. Controls the vertical thickness of the disk.

* **Sigma0** (``1.0``): Reference surface density at the reference radius. Sets the overall mass scale of the disk.

* **Nu** (``1.0e-5``): Kinematic viscosity coefficient. Controls the strength of viscous diffusion in the disk.

* **SigmaSlope** (``0.0``): Power-law slope for the initial surface density profile. A value of 0.0 means uniform surface density.

* **FlaringIndex** (``0.0``): Disk flaring index. Controls how the disk scale height varies with radius. A value of 0.0 means no flaring.

* **DampingZone** (``1.15``): Radial range for applying damping zones (in period-ratios). Values smaller than 1.0 disable damping. Damping zones prevent wave reflections at boundaries.

* **TauDamp** (``0.3``): Characteristic damping time in units of the inverse local orbital frequency. Higher values result in weaker damping.

Planet Parameters
~~~~~~~~~~~~~~~~~

* **PlanetMass** (``1e-03``): Mass of the planet in units of the central star mass. Controls the strength of planet-disk gravitational interactions.

* **PlanetMassFile** (``cfg``): Source for planet mass data. Can be ``cfg`` to use configuration file values or a file path.

* **PlanetConfig** (``planets/jupiter.cfg``): Path to the planet configuration file containing orbital parameters.

* **ThicknessSmoothing** (``0.6``): Smoothing length for the planet's gravitational potential in units of the disk scale height. Prevents numerical singularities near the planet.

* **RocheSmoothing** (``0.0``): Smoothing length based on the planet's Roche radius. A value of 0.0 disables Roche-based smoothing.

* **Eccentricity** (``0.0``): Initial orbital eccentricity of the planet. A value of 0.0 means a circular orbit.

* **ExcludeHill** (``no``): Whether to exclude the Hill sphere region from the computation. Options: ``yes`` or ``no``.

* **IndirectTerm** (``yes``): Whether to include the indirect term (acceleration of the coordinate frame) due to planet-star gravitational interaction. Options: ``yes`` or ``no``.

Mesh Parameters
~~~~~~~~~~~~~~~

* **Nx** (``1536``): Number of grid cells in the azimuthal (X) direction.

* **Ny** (``1024``): Number of grid cells in the radial (Y) direction.

* **Xmin** (``-3.14159265358979323844``): Minimum azimuthal coordinate (typically -π for a full disk).

* **Xmax** (``3.14159265358979323844``): Maximum azimuthal coordinate (typically +π for a full disk).

* **Ymin** (``0.4``): Inner radial boundary of the computational domain.

* **Ymax** (``2.5``): Outer radial boundary of the computational domain.

* **OmegaFrame** (``1.0005``): Angular velocity of the rotating reference frame. Often set slightly above the planet's orbital frequency to account for migration.

* **Frame** (``G``): Reference frame type. ``G`` indicates a rotating frame corotating with the planet.

Output Control Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~

* **DT** (``0.314159265359``): Time interval between output snapshots in code units. For this configuration, one orbit equals approximately 20 DT.

* **Ninterm** (``5``): Number of intermediate time steps between outputs.

* **Ntot** (``200``): Total number of output snapshots to produce.

* **OutputDir** (``@outputs``): Directory for storing FARGO3D output files. The ``@`` symbol indicates a path relative to the run directory.

Plotting Parameters
~~~~~~~~~~~~~~~~~~~

* **PlotLog** (``yes``): Whether to use logarithmic scale for plotting. Options: ``yes`` or ``no``.

PINN Training Parameters
-------------------------

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
