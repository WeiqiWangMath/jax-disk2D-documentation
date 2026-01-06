Introduction
============

jax-disk2D is a Python package that implements Physics-Informed Neural Networks (PINNs) for solving two-dimensional, time-dependent hydrodynamics of non-self-gravitating accretion disks. This package provides the first demonstration of PINNs as surrogate solvers for accretion disk dynamics, enabling physics-driven, data-free modeling of complex astrophysical systems.

The following comparison demonstrates the accuracy of our PINN approach. The left video shows the PINN prediction, while the right video shows the reference solution from FARGO3D (a widely-used hydrodynamics code for astrophysical disk simulations):

.. raw:: html

   <div class="video-group video-group-2">
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">PINN Prediction</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-truth.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">FARGO3D Reference</div>
       </div>
   </div>

What are Physics-Informed Neural Networks?
-------------------------------------------

Physics-Informed Neural Networks (PINNs) represent a paradigm shift in scientific computing. Unlike data-driven machine learning approaches that require large datasets of precomputed solutions, PINNs learn directly from physical laws without needing training data. The key innovation is embedding the governing partial differential equations (PDEs) directly into the neural network's loss function, enabling data-free learning that respects physical laws.

In jax-disk2D, the PINN maps spatiotemporal coordinates (radius, azimuth, time) = (r, θ, t) to the physical solution variables: surface density Σ, radial velocity v_r, and azimuthal velocity v_θ. The network learns to satisfy:

* **Continuity equation**: Conservation of mass
* **Momentum equations**: Conservation of momentum in radial and azimuthal directions
* **Initial conditions**: The system's state at t = 0
* **Boundary conditions**: Physical constraints at domain boundaries

This implementation successfully reproduces key physical phenomena in accretion disk dynamics, including spiral density waves, gap formation, and long-term stable evolution. The boundary-free approach enabled by PINNs naturally suppresses spurious wave reflections at disk edges, which are challenging to eliminate in traditional numerical simulations that require explicit boundary conditions and damping zones.

Documentation Guide
-------------------

This documentation is organized to help you get started quickly and find detailed information as needed:

* **Installation**: Step-by-step guide for setting up jax-disk2D on computers with GPU, using ComputeCanada HPC clusters as an example
* **Getting Started**: Complete workflow from running FARGO3D simulations through training PINN models to visualizing results
* **Downloading Pre-computed Data**: Access pre-existing FARGO3D runs and trained PINN models from Hugging Face to skip lengthy simulations
* **Default Parameters**: Comprehensive reference for all FARGO3D simulation and PINN training parameters with detailed explanations
* **Test Results**: Visual comparisons showing how parameter variations affect PINN predictions
* **Project Structure**: Overview of the repository organization with detailed descriptions of all modules and files

References
----------

This codebase implements the methods described in:

**Mao et al. (2025)**: "Neural Networks as Surrogate Solvers for Time-dependent Accretion Disk Dynamics", *The Astrophysical Journal Letters*, 992:L20. `DOI: 10.3847/2041-8213/ae0b60 <https://doi.org/10.3847/2041-8213/ae0b60>`_

FARGO3D is used for validation and reference solutions:

* **FARGO3D Documentation**: `https://fargo3d.github.io/documentation/ <https://fargo3d.github.io/documentation/>`_
* **FARGO3D Paper**: Benítez-Llambay & Masset (2016), *The Astrophysical Journal Supplement Series*, 223:11. `DOI: 10.3847/0067-0049/223/1/11 <https://iopscience.iop.org/article/10.3847/0067-0049/223/1/11>`_

