Techniques
==========

This page discusses the various techniques we explored during the development of this PINN framework.

Sampling Strategies
-------------------

We tested planet-focused and spiral arm sampling strategies, which were designed based on empirical fitting to the solution, to concentrate collocation points in regions of interest, such as near the planet location and along the spiral density wave structures. However, these adaptive sampling methods showed no significant improvement in the final accuracy compared to uniform random sampling. Therefore, we kept uniform random sampling in polar coordinates over the domain :math:`[r_{\text{min}}, r_{\text{max}}] \times [-\pi, \pi] \times [t_{\text{min}}, t_{\text{max}}]` as the default approach due to its simplicity and comparable performance. Other potential sampling strategies, such as spatiotemporal adaptive sampling and wave front sampling, were not tested.
