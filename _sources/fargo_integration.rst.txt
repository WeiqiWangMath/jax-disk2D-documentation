FARGO3D Integration
===================

jax-disk2D integrates with FARGO3D for validation and comparison purposes. FARGO3D is a well-established grid-based hydrodynamic solver that provides reference solutions against which PINN results can be validated. For detailed information about FARGO3D itself, see the `official FARGO3D documentation <https://github.com/FARGO3D/documentation>`_.

.. note::

   The basic workflow for getting, compiling, and running FARGO3D simulations is covered in the :doc:`getting_started` guide. This section focuses on the configuration parameters used in jax-disk2D.

Default Configuration: fargo2_run.yml
--------------------------------------

The default FARGO3D setup used in jax-disk2D is defined in ``fargo2_run.yml``. This configuration simulates a 2D accretion disk with a low-mass companion (planet) and provides the **physics settings for PINN training**. The physical parameters defined here (disk properties, planet mass, domain boundaries, etc.) determine the physical system that the PINN will learn to solve.

All parameters described below are standard FARGO3D parameters and are documented in detail in the `FARGO3D documentation <https://github.com/FARGO3D/documentation>`_. The parameters are organized into several categories:

Disk Parameters
~~~~~~~~~~~~~~~

* **AspectRatio** (0.05): The disk aspect ratio, defined as H/r where H is the disk scale height and r is the radial coordinate. A value of 0.05 corresponds to a thin disk.

* **Sigma0** (1.0): The reference surface density normalization factor.

* **Nu** (1.0e-5): The kinematic viscosity coefficient. This controls the strength of viscous diffusion in the disk.

* **SigmaSlope** (0.0): The power-law index for the initial surface density profile. A value of 0.0 corresponds to a flat surface density profile.

* **FlaringIndex** (0.0): The flaring index for the disk scale height. A value of 0.0 means the scale height is constant with radius.

Damping Zone Parameters
~~~~~~~~~~~~~~~~~~~~~~~

* **DampingZone** (1.15): The radial range for wave damping, specified in period-ratios. Values smaller than one prevent damping. This parameter controls the location where waves are damped near the domain boundaries to prevent spurious reflections.

* **TauDamp** (0.3): The characteristic damping time, in units of the inverse local orbital frequency. Higher values mean lower damping (weaker damping).

Planet Parameters
~~~~~~~~~~~~~~~

* **PlanetMass** (1e-05): The planet mass in units of the central star mass. A value of 1e-05 corresponds to a low-mass companion (approximately 10 Earth masses for a solar-mass star).

* **PlanetMassFile** (cfg): Specifies that planet mass is read from a configuration file.

* **PlanetConfig** (planets/jupiter.cfg): Path to the planet configuration file.

* **ThicknessSmoothing** (0.6): The smoothing length for the planet's gravitational potential, in units of the disk scale height. This prevents numerical singularities.

* **RocheSmoothing** (0.0): Additional smoothing for the Roche potential. A value of 0.0 means no additional smoothing.

* **Eccentricity** (0.0): The orbital eccentricity of the planet. A value of 0.0 corresponds to a circular orbit.

* **ExcludeHill** ('no'): Whether to exclude the Hill sphere from the simulation domain. Set to 'no' to include it.

* **IndirectTerm** ('yes'): Whether to include the indirect term in the gravitational potential, accounting for the motion of the central star due to the planet.

Mesh Parameters
~~~~~~~~~~~~~~~

* **Nx** (1536): Number of grid cells in the azimuthal (θ) direction.

* **Ny** (1024): Number of grid cells in the radial (r) direction.

* **Xmin** (-π): Minimum azimuthal coordinate (in radians). The value -π to π covers the full 2π azimuthal domain.

* **Xmax** (π): Maximum azimuthal coordinate (in radians).

* **Ymin** (0.4): Minimum radial coordinate in code units. This defines the inner boundary of the disk.

* **Ymax** (2.5): Maximum radial coordinate in code units. This defines the outer boundary of the disk.

* **OmegaFrame** (1.0005): The angular velocity of the reference frame. This is slightly larger than the Keplerian frequency at the planet's location, placing the frame in a slightly super-Keplerian state.

* **Frame** (G): The reference frame type. 'G' indicates a frame that rotates with the planet.

Output Control Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~

* **DT** (0.314159265359): The time step in code units. One orbit corresponds to 2π ≈ 6.28, so with DT ≈ 0.314, one orbit is approximately 20 time steps.

* **Ninterm** (5): The number of time steps between intermediate outputs. Outputs are saved every 5 time steps.

* **Ntot** (100): The total number of intermediate outputs. With Ninterm=5, this corresponds to 500 time steps total, or approximately 25 orbits.

* **OutputDir** ('@outputs'): The directory where output files are saved. The '@outputs' is a Guild AI placeholder that gets resolved to the appropriate output directory.

Plotting Parameters
~~~~~~~~~~~~~~~~~~~

* **PlotLog** ('yes'): Whether to use logarithmic scaling for plotting. Set to 'yes' for better visualization of density variations.

Customizing Parameters
----------------------

You can override any of these parameters when running a simulation. For example, to change the number of orbits:

.. code-block:: bash

   guild run fargo:run @fargo2_run.yml Ntot=100

This changes ``Ntot`` to 100, which with the default ``Ninterm=5`` and ``DT≈0.314`` corresponds to approximately 25 orbits.

For more advanced customization, you can create your own configuration file based on ``fargo2_run.yml`` and modify the parameters as needed. All parameters are fully documented in the `FARGO3D documentation <https://github.com/FARGO3D/documentation>`_, which provides detailed explanations of their physical and numerical meanings. When modifying these parameters, keep in mind that they define the physical system that your PINN will be trained to solve.

