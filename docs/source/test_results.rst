Test Results
============

This page presents comparisons of PINN predictions with varying parameters to demonstrate the model's behavior under different configurations.

Parameter Variations
--------------------

The following tests explore how changing key parameters from the default configuration affects the PINN predictions. All tests use the same base setup unless otherwise specified. For the default parameter values, see :doc:`default_parameters`.

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
