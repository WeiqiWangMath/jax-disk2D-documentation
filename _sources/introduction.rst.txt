Introduction
============

jax-disk2D is a Python package for solving 2D disk hydrodynamics problems using Physics-Informed Neural Networks (PINNs) with JAX. The package integrates with FARGO3D for generating training data and provides a complete workflow for training and evaluating PINN models.

Key Features
------------

* **Physics-Informed Neural Networks**: Solve 2D disk hydrodynamics using neural networks constrained by physical laws
* **FARGO3D Integration**: Seamlessly work with FARGO3D simulations for data generation
* **JAX-based**: Leverage JAX for high-performance automatic differentiation and GPU acceleration
* **Guild AI Workflow**: Use Guild AI for experiment management and reproducibility
* **Flexible Configuration**: Easy-to-use configuration system for different simulation setups

What is a PINN?
---------------

Physics-Informed Neural Networks (PINNs) are neural networks that are trained to satisfy both:
 
* **Data constraints**: Match observed or simulated data
* **Physics constraints**: Satisfy partial differential equations (PDEs) that govern the physical system

In jax-disk2D, the PINN learns to solve the 2D disk hydrodynamics equations by:
 
* Learning from FARGO3D simulation data
* Enforcing the continuity and momentum equations as loss terms
* Satisfying boundary conditions and initial conditions

Project Structure
-----------------

The package is organized into several main components:

* ``jaxdisk2D/physics_informed_training/``: Core PINN training modules
* ``fargo_utils/``: Utilities for working with FARGO3D
* ``fargo_data_process/``: Tools for processing FARGO3D output data
* ``guild.yml``: Guild AI workflow definitions

