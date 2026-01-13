Test Results
============

This page presents comparisons of PINN predictions with varying parameters to demonstrate the model's behavior under different configurations. 
The following tests explore how changing key parameters from the default configuration affects the PINN predictions. All tests use the same base setup unless otherwise specified. For the default parameter values, see :doc:`default_parameters`.

PINN vs FARGO3D Comparison
---------------------------

This comparison directly shows the PINN prediction, FARGO3D reference solution, and the error between them. The PINN was trained with default parameters (6.4 million epochs, 32-bit precision).

.. raw:: html

   <div class="video-group video-group-3">
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
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-error.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">Error (PINN - FARGO3D)</div>
       </div>
   </div>

All three videos play synchronously. The error map demonstrates that the PINN achieves high accuracy in reproducing the FARGO3D solution.

Number of Training Epochs
----------------------------

This comparison shows how the number of training epochs affects the quality of PINN predictions. The videos show surface density evolution with different training durations: 3.2 million epochs, 6.4 million epochs (default), 12.8 million epochs, and the FARGO3D reference solution. All other parameters remain at their default values.

.. raw:: html

   <div class="video-group video-group-4">
       <div class="video-item">
           <video controls>
               <source src="movies/a6b70ae0/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">3.2M Epochs</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">6.4M Epochs (Default)</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/1f1dc333/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">12.8M Epochs</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-truth.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">FARGO3D Reference</div>
       </div>
   </div>

All four videos play synchronously. The comparison demonstrates that the PINN converges to an accurate solution by 6.4 million epochs, with marginal improvements at 12.8 million epochs.

Effect of Numerical Precision
------------------------------

This comparison examines the impact of floating-point precision on PINN predictions. The videos show results using 32-bit precision (default), 64-bit precision, and the FARGO3D reference solution. Both models were trained for 6.4 million epochs with all other parameters kept at default values.

.. raw:: html

   <div class="video-group video-group-3">
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">32-bit Precision (Default)</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a72e29f4/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">64-bit Precision</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-truth.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">FARGO3D Reference</div>
       </div>
   </div>

All three videos play synchronously. The comparison shows that 64-bit precision takes longer to train but provides slightly better accuracy compared to 32-bit precision.

Effect of Domain Sampling Density
----------------------------------

This comparison shows how the number of collocation points sampled in the spatiotemporal domain affects PINN predictions. The videos compare results using 5,000 domain samples, 10,000 samples (default), 20,000 samples, and the FARGO3D reference solution. All models were trained for 6.4 million epochs with other parameters at default values.

.. raw:: html

   <div class="video-group video-group-4">
       <div class="video-item">
           <video controls>
               <source src="movies/8567f228/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">5,000 Samples</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">10,000 Samples (Default)</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/32a4fb47/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">20,000 Samples</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-truth.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">FARGO3D Reference</div>
       </div>
   </div>

All four videos play synchronously. The 5000 sample video shows lack of accuracy. The comparison demonstrates that 10,000 domain samples provide a good balance between computational cost and accuracy, with marginal improvements at higher sampling densities.

Effect of Network Depth
------------------------

This comparison examines how the number of hidden layers in the MLP affects PINN predictions. The videos compare networks with 5, 9 (default), and 11 hidden layers, all with 32 neurons per layer, along with the FARGO3D reference solution. All models were trained for 6.4 million epochs with other parameters at default values.

.. raw:: html

   <div class="video-group video-group-4">
       <div class="video-item">
           <video controls>
               <source src="movies/cdf7e72a/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">5 Layers</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">9 Layers (Default)</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/ef971b06/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">11 Layers</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-truth.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">FARGO3D Reference</div>
       </div>
   </div>

All four videos play synchronously. The comparison shows that 5 layers provide the worst accuracy, while 9 and 11 layers show no significant difference in performance. Therefore, 9 layers are used as the default to balance accuracy and computational efficiency.

Effect of Network Width vs Depth
---------------------------------

This comparison examines the trade-off between network width and depth. The videos compare a wider but shallower network (4 layers × 128 nodes per layer) with the default deeper but narrower network (9 layers × 32 nodes per layer), along with the FARGO3D reference solution. Both models were trained for 6.4 million epochs with other parameters at default values.

.. raw:: html

   <div class="video-group video-group-3">
       <div class="video-item">
           <video controls>
               <source src="movies/ea59b5082/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">4 Layers × 128 Nodes</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">9 Layers × 32 Nodes (Default)</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-truth.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">FARGO3D Reference</div>
       </div>
   </div>

All three videos play synchronously. The comparison demonstrates the effectiveness of the default deeper architecture for this application.

Effect of Time-Window Overlap Ratio
------------------------------------

This comparison examines how the overlap between consecutive time windows in the time-marching strategy affects PINN predictions. The videos compare three overlap ratios: 0 (no overlap), 0.2 (default), and 0.4, along with the FARGO3D reference solution. All models were trained for 6.4 million epochs with other parameters at default values.

.. raw:: html

   <div class="video-group video-group-4">
       <div class="video-item">
           <video controls>
               <source src="movies/3c51e831/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">0 Overlap Ratio</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">0.2 Overlap Ratio (Default)</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/853515b5/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">0.4 Overlap Ratio</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-truth.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">FARGO3D Reference</div>
       </div>
   </div>

All four videos play synchronously. The time-marching strategy with overlapping windows helps ensure smooth transitions between consecutive time intervals, with 0.2 overlap providing a good balance.

Effect of Number of Time-Marching Folds
----------------------------------------

This comparison examines how the number of time windows in the time-marching strategy affects PINN predictions. The videos compare using 8 time folds versus 32 folds (default), along with the FARGO3D reference solution. All models were trained for 6.4 million epochs with other parameters at default values.

.. raw:: html

   <div class="video-group video-group-3">
       <div class="video-item">
           <video controls>
               <source src="movies/bb2d2f02/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">8 Time Folds</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">32 Time Folds (Default)</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-truth.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">FARGO3D Reference</div>
       </div>
   </div>

All three videos play synchronously. Using more time folds allows for better resolution of the temporal evolution and more stable long-term predictions.

Effect of Activation Function
------------------------------

This comparison examines how different activation functions affect PINN predictions. The videos compare tanh, sin, and stan (default) activation functions, along with the FARGO3D reference solution. All models were trained for 6.4 million epochs with other parameters at default values.

.. raw:: html

   <div class="video-group video-group-4">
       <div class="video-item">
           <video controls>
               <source src="movies/0bb155ba/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">tanh Activation</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/3174b375/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">sin Activation</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-predict.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">stan Activation (Default)</div>
       </div>
       <div class="video-item">
           <video controls>
               <source src="movies/a123c105/dens-truth.mp4" type="video/mp4">
               Your browser does not support the video tag.
           </video>
           <div class="video-caption">FARGO3D Reference</div>
       </div>
   </div>

All four videos play synchronously. The comparison demonstrates that the stan activation function performs better than tanh and sin for this disk hydrodynamics scenario.
