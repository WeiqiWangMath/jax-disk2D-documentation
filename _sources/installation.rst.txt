Installation
============

Prerequisites
-------------

* Python 3.8 or higher
* pip package manager
* (Optional) CUDA toolkit for GPU support

Installing Python Dependencies
-------------------------------

Clone the repository and install the required dependencies:

.. code-block:: bash

   cd jax-disk2D
   pip install -r requirements.txt

MPI Support
-----------

For netCDF4 support, you may need to install ``mpi4py``:

.. code-block:: bash

   pip install mpi4py

**Note**: On Compute Canada systems, do NOT install mpi4py via pip. It should be loaded via the module system instead.

Environment Variables
---------------------

Set up the following environment variables:

.. code-block:: bash

   export JAX_DISK2D_HOME=<path_to_jax-disk2D>
   export JAX_DISK2D_VENV=<path_to_virtual_venv>
   export JAX_DISK2D_GUILD_HOME=<path_to_guild_home>

Guild AI
--------

jax-disk2D uses `Guild AI <https://my.guild.ai/t/guild-ai-documentation/64>`_ for workflow management. 
Check ``guild.yml`` for more information on available operations.

Verifying Installation
----------------------

After installation, you can verify that the package is working by running:

.. code-block:: bash

   python -c "import jaxdisk2D; print('jax-disk2D installed successfully')"

