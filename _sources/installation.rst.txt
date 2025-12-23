Installation
============

This guide provides detailed step-by-step instructions for installing jax-disk2D on ComputeCanada clusters with GPU support. While the installation procedure is similar across different HPC platforms, we use the Fir cluster as a specific example. Users on other systems (e.g., Cedar, Graham, Narval, or other HPC clusters) should adapt the instructions accordingly, particularly the cluster hostname and module versions.

For more comprehensive information about using ComputeCanada clusters, please refer to the official `Alliance Canada Technical Documentation <https://docs.alliancecan.ca/wiki/Technical_documentation>`_.

Prerequisites
-------------

Before you begin, ensure you have:

* Access to a ComputeCanada cluster account (e.g., Fir cluster)
* SSH client installed on your local machine
* Your ComputeCanada username and password

Installation on ComputeCanada Clusters
---------------------------------------------

Step 1: Connect to the Cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open a terminal on your local machine and SSH into the cluster. Replace ``<username>`` with your ComputeCanada username:

.. code-block:: bash

   ssh <username>@fir.alliancecan.ca

When prompted, enter your password. After successful login, you will be on the login node.

**Important**: Do not run computationally intensive tasks on login nodes. They are only for file management and job submission.

Step 2: Navigate to Your Project Directory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Navigate to your project allocation space and create a working directory. Replace ``<project_id>`` with your research group's project identifier (e.g., ``def-supervisor`` or ``rrg-groupname``), ``<username>`` with your username, and ``<jax-disk2D-workdir-name>`` with your preferred directory name (e.g., ``jax-disk2D-workspace``):

.. code-block:: bash

   cd /project/<project_id>/<username>
   mkdir -p <jax-disk2D-workdir-name>
   cd <jax-disk2D-workdir-name>

**Note**: Your ``<project_id>`` is the resource allocation identifier for your research group on ComputeCanada. You can find this by running ``groups`` or checking your allocation on the CCDB (ComputeCanada Database). Project space typically has much more storage than your home directory.

Step 3: Clone the Repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Clone the jax-disk2D repository from GitHub:

.. code-block:: bash

   git clone https://github.com/smao-astro/jax-disk2D.git
   cd jax-disk2D

Switch to the ``code-cleanup`` branch:

.. code-block:: bash

   git checkout code-cleanup

Step 4: Load Required Modules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ComputeCanada clusters use environment modules to manage software. Load the necessary modules for GPU-accelerated JAX with Python 3.11:

.. code-block:: bash

   module load StdEnv/2023
   module load python/3.11
   module load cuda/12.2
   module load cudnn/8.9.5.29

Step 5: Create a Virtual Environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create a Python virtual environment inside your working directory to isolate your dependencies. Go back to your workspace directory first:

.. code-block:: bash

   cd ..
   python -m venv jax-disk2D-venv

Activate the virtual environment:

.. code-block:: bash

   source jax-disk2D-venv/bin/activate

After activation, your command prompt should change to show ``(jax-disk2D-venv)`` at the beginning, indicating that the virtual environment is active.

**Important**: You must activate this virtual environment every time you log in and want to use jax-disk2D.

Return to the jax-disk2D repository directory:

.. code-block:: bash

   cd jax-disk2D


Step 6: Install Python Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install all required Python packages from the requirements file:

.. code-block:: bash

   pip install -r requirements.txt

This will install JAX with CUDA 12 support, along with all other dependencies including:

* JAX and related packages (jaxlib, dm-haiku, optax)
* Scientific computing libraries (numpy, scipy, pandas)
* Data handling tools (xarray, netCDF4)
* Visualization tools (matplotlib, tensorboard)
* Guild AI for workflow management

**Note**: The installation may take 10-15 minutes depending on network speed. If you encounter any timeout errors, try running the command again.

Step 7: Install mpi4py via Module System
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For netCDF4 parallel I/O support, load mpi4py through the module system instead of pip:

.. code-block:: bash

   module load mpi4py

**Warning**: Do NOT install mpi4py via pip on ComputeCanada systems. Using the module system ensures compatibility with the cluster's MPI implementation.

Step 8: Set Up Environment Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create a setup script to configure environment variables. This makes it easier to set up your environment in future sessions.

First, create a directory for Guild AI data in your scratch space. Guild AI stores run data, logs, and artifacts which can grow large, so we place it in scratch storage. **Note**: On ComputeCanada, scratch directories are automatically cleaned every 60 days, so backup important results regularly:

.. code-block:: bash

   mkdir -p $HOME/scratch/guild-data

Now create the environment setup script. Replace ``<workspace-dir>`` with the absolute path to your jax-disk2D workspace (e.g., ``/project/<project_id>/<username>/<jax-disk2D-workdir-name>``):

.. code-block:: bash

   export JAX_DISK2D_HOME=${WORKSPACE_DIR}/jax-disk2D
   export JAX_DISK2D_VENV=${WORKSPACE_DIR}/jax-disk2D-venv
   export JAX_DISK2D_GUILD_HOME=$HOME/scratch/guild-data
   export GUILD_HOME=$HOME/scratch/guild-data




Next Steps
----------

After successful installation, proceed to the :doc:`getting_started` section to:

* Configure your first simulation
* Run training on compute nodes with GPU resources
* Download sample data (optional)
