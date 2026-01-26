Techniques
==========

This page discusses the various techniques we explored during the development of this PINN framework.

Sampling Strategies
-------------------

We tested planet-focused and spiral arm sampling strategies, which were designed based on empirical fitting to the solution, to concentrate collocation points in regions of interest, such as near the planet location and along the spiral density wave structures. However, these adaptive sampling methods showed no significant improvement in the final accuracy compared to uniform random sampling. Therefore, we kept uniform random sampling in polar coordinates over the domain :math:`[r_{\text{min}}, r_{\text{max}}] \times [-\pi, \pi] \times [t_{\text{min}}, t_{\text{max}}]` as the default approach due to its simplicity and comparable performance. Other potential sampling strategies, such as spatiotemporal adaptive sampling and wave front sampling, were not tested.

Frame Angular Velocity
----------------------

The frame angular velocity :math:`\Omega_{\text{frame}}` used in the rotating reference frame is derived from Kepler's third law. For a corotating frame with the planet, the angular velocity is :math:`\Omega_{\text{frame}} = \sqrt{G(M_* + m_p)/r_p^3} = \sqrt{1 + 10^{-5}} \approx 1.000005` in FARGO3D units, where :math:`M_*` is the stellar mass, :math:`m_p` is the planet mass, and :math:`r_p` is the planet orbital radius. This formulation correctly accounts for the gravitational influence of both the star and the planet, ensuring consistency between the PINN governing equations and the FARGO3D reference simulations.

Time-Stepping-Oriented Neural Network (TSONN)
----------------------------------------------

We considered the Time-Stepping-Oriented Neural Network (TSONN) approach proposed by `Cao and Zhang (2023) <https://arxiv.org/abs/2310.16491>`_, which integrates time-stepping methods with deep learning to transform the ill-conditioned optimization problem into a series of well-conditioned sub-problems over pseudo time intervals. While this method shows promise for improving training stability in time-dependent PDEs, our initial consideration raised the question: if we are incorporating time-stepping methods into the neural network framework, why not directly use traditional numerical methods? Nevertheless, TSONN represents a potentially feasible approach to make PINNs work more effectively for time-dependent problems, and it could be worth exploring in future work for challenging scenarios where standard PINNs struggle with training convergence.

Causal Training
---------------

We tested the causal training approach proposed by `Wang et al. (2022) <https://arxiv.org/abs/2203.07404>`_, which emphasizes respecting the spatio-temporal causal structure in time-dependent PDEs. This method prioritizes achieving better accuracy at earlier times before progressively training on later time steps, following the physical causality of the system evolution. This is a well-motivated approach that has been shown to work effectively for many time-dependent problems, including chaotic and turbulent systems. We implemented this method and experimented with different values for key parameters including ``causal_training_epsilon`` (which controls the temporal window size) and ``causal_stopping_criterion`` (which determines when to advance to the next temporal window). However, despite tuning these parameters across various configurations, the causal training approach did not improve results for our disk hydrodynamics equations. The reasons for this failure are not entirely clear, but it suggests that our specific problem may have characteristics that do not align well with the assumptions underlying causal training methods.

Enforcing Periodic Boundary Conditions
---------------------------------------

We tested the method proposed by `Dong and Ni (2021) <https://doi.org/10.1016/j.jcp.2021.110242>`_ for exactly enforcing periodic boundary conditions with deep neural networks. This method represents a different approach compared to our standard implementation of periodic boundary conditions. It constructs specialized periodic layers that automatically satisfy periodicity requirements for the function and its derivatives to machine precision. We suspected that our construction for imposing periodic boundary conditions might cause some issues in the training process, and we explored this alternative method to see if it could address potential problems. However, in our implementation and testing, this approach did not improve the performance of our PINN solver for the disk hydrodynamics problem. We ultimately found that our standard methods for handling periodic boundary conditions were sufficient for our application.

Time-Marching Error Accumulation
---------------------------------

We examined the error accumulation behavior of the time-marching strategy as a function of time for different numbers of time folds. Our analysis shows that the error increases approximately linearly during the first few orbital periods, then reaches a plateau and remains relatively flat for the remainder of the simulation. This behavior is consistent across different time-marching configurations, with similar error evolution patterns observed for both 16 and 32 time folds. This suggests that the error accumulation in the time-marching approach is not strongly sensitive to the number of folds once a sufficient number is used, and that the dominant error contribution occurs during the initial propagation phase.

Time-Marching Initialization Strategy
--------------------------------------

For the time-marching approach, we explored two initialization strategies for each temporal fold: (1) using the previous fold's trained weights and biases as initialization for the current fold, or (2) random initialization for each fold's network. We tested both approaches and found that using the previous fold's weights as initialization did not work well. The model failed to converge properly or produced inaccurate results when initialized this way. Consequently, we adopted random initialization (using Glorot normal initialization) for each fold's network in the current implementation. Each time fold starts with a freshly initialized neural network, which is then trained independently on its respective time window with data constraints from the previous fold to ensure continuity.

Radial Boundary Conditions
---------------------------

An important finding in our work concerns the treatment of radial boundary conditions. In our initial implementation, we imposed boundary conditions at the inner and outer radial boundaries to match the FARGO reference simulations. However, through careful analysis of the PINN solution, we observed that while the solution evolved correctly during the first few orbital periods, the density waves generated by the planet stopped propagating away from the planet location after approximately 4-5 orbits. This premature cessation of wave propagation was inconsistent with the expected physical behavior. After removing the radial boundary conditions and allowing the PINN to solve the governing equations without explicit boundary constraints at :math:`r_{\text{min}}` and :math:`r_{\text{max}}`, the waves were able to propagate correctly and reach the domain boundaries as expected. This finding suggests that for this particular problem, the boundary conditions may have been over-constraining the solution and preventing the PINN from capturing the correct wave dynamics.

Training with Larger Domain
----------------------------

We experimented with training the PINN on a larger radial domain to assess whether the model could generalize to a wider spatial extent. However, the results showed significant degradation in accuracy compared to the reference solution, particularly in the outer region where :math:`2.5 < r < 4.0`. The PINN struggled to reproduce the correct solution structure in this extended domain. This suggests that the increased complexity of the solution over a larger domain poses challenges for the neural network to learn effectively. The network capacity and training procedure that worked well for the standard domain were insufficient for capturing the more complex dynamics present in the extended region. This highlights a limitation of PINNs when dealing with spatially extended problems where solution complexity grows with domain size.

Damping in FARGO Simulations
-----------------------------

We explored the possibility of removing the wave damping mechanism in FARGO simulations, as we initially suspected that the damping might be causing inaccuracies in the reference solution. Wave damping is typically applied near the domain boundaries to prevent spurious reflections and ensure numerical stability. However, our experiments showed that removing damping was not a viable approach. The damping mechanism is essential in the current FARGO setup to maintain physically meaningful solutions and prevent artificial wave reflections from contaminating the interior solution. This confirmed that the FARGO solution with damping provides the correct reference data, and we retained the standard damping configuration in our reference FARGO simulations.

Equation Form Reformulation
---------------------------

Some research has shown that changing the form of governing equations can provide advantages in PINN training. For example, `Kharazmi et al. (2021) <https://doi.org/10.1016/j.cma.2020.113547>`_ demonstrated that using variational formulations and integration by parts can reduce the order of differential operators and improve training efficiency, particularly for problems with rough solutions or singularities. We considered exploring different equation formulations for our disk hydrodynamics problem. However, the governing equations (continuity, momentum, and energy equations in rotating coordinates) are already quite complex, involving multiple nonlinear terms and coupling between variables. Reformulating these equations would make verification of correctness challenging, and without clear evidence about which direction would be beneficial for our specific problem, we decided not to pursue this path. We retained the standard strong-form PDEs in our implementation.

Numerical Precision
-------------------

Many research studies indicate that double precision (64-bit) can largely improve the accuracy of PINNs, particularly for problems requiring high-order derivative computations. However, in our case, while 64-bit precision does provide some improvement over 32-bit precision, the enhancement is only limited. As shown in the test results comparing 32-bit and 64-bit precision (see :doc:`test_results`), the accuracy gains are modest and come at the cost of significantly longer training times and increased memory usage. We therefore use 32-bit precision as the default configuration, which provides a good balance between computational efficiency and solution accuracy for this disk hydrodynamics application.

OutScaled MLP
-------------

We tested an outscaled MLP architecture variant in addition to the standard MLP. The outscaled MLP approach applies scaling transformations to the network outputs to better match the expected range of physical quantities. However, our experiments showed that the outscaled MLP did not perform better than the simple standard MLP for our disk hydrodynamics problem. Consequently, we use the standard MLP architecture in the current version, which consists of fully connected layers with configurable activation functions and layer sizes (default: 9 layers with 32 neurons per layer).

Fourier Features
----------------

We tested random Fourier features, a technique that addresses the spectral bias of neural networks by enabling them to learn high-frequency functions more effectively (`Tancik et al., 2020 <https://arxiv.org/abs/2006.10739>`_). The Fourier feature layer uses random weights in the first layer to map inputs to a higher-dimensional space with sinusoidal functions, which has been shown to be beneficial for many tasks. Despite the theoretical advantages and success in other applications, Fourier features did not improve the performance of our PINN for the disk hydrodynamics problem. We therefore retained the standard network architecture without Fourier feature mappings.

Parallel Networks for Multiple Outputs
---------------------------------------

Inspired by the DeepONet architecture (`Lu et al., 2021 <https://doi.org/10.1038/s42256-021-00302-5>`_), we tested a parallel network approach where each physical quantity (:math:`\Sigma`, :math:`v_r`, :math:`v_\theta`) is predicted by a separate neural network. The motivation was to eliminate potential interference between different output variables during training, allowing each network to specialize in learning its respective quantity independently. However, the results from this parallel network configuration were not promising and did not show improvement over the standard single network approach that predicts all three quantities simultaneously. We therefore retained the unified network architecture where all outputs share the same network parameters.

Robustness Across Physical Parameters
--------------------------------------

We extensively tested the robustness of our PINN framework across different physical parameter configurations, specifically varying the planet mass and disk aspect ratio. We evaluated the model on combinations of planet masses :math:`m_p \in \{10^{-3}, 10^{-4}, 10^{-5}\}` (in units of stellar mass) and aspect ratios :math:`h \in \{0.05, 0.1, 0.15\}`. Our results demonstrate that the PINN is robust across these parameter variations, consistently producing solutions that closely approximate the FARGO3D reference solutions. This finding indicates that the PINN architecture and training approach we developed can reliably capture the underlying physics of planet-disk interactions across a range of physically relevant parameter regimes, rather than being limited to a single narrow configuration.

Memory Considerations
---------------------

When running ``pinn:train``, users should be aware that the test function called at the end of training is memory-intensive. This function loads the full test dataset and generates predictions on the entire spatiotemporal grid, which requires substantial memory allocation. Although the current version includes optimizations to reduce memory usage, the operation still requires considerable memory resources. We recommend using at least 64GB of RAM when running training jobs to avoid out-of-memory errors, especially for large-scale simulations with fine spatial and temporal resolution.

Multi-GPU Training
------------------

We did not implement multi-GPU training for this work. The primary reasons are that our batch size (10,000 collocation points) is not sufficiently large to benefit from multi-GPU parallelization, the model size is relatively small (9 layers with 32 neurons per layer by default), and implementing multi-GPU training would require significant code modifications using JAX's parallel primitives such as ``pmap``. Given these considerations, the engineering effort required for multi-GPU support would likely outweigh the potential speedup benefits for our problem configuration. Single-GPU training proved sufficient for our computational needs.
