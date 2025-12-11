Hugging Face Integration
========================

jax-disk2D provides integration with Hugging Face for downloading pre-computed simulation data and model checkpoints.

Downloading Data from Hugging Face
------------------------------------

Use the ``download_data.py`` helper script to download data snapshots stored on Hugging Face. The script wraps ``huggingface_hub.snapshot_download`` and allows you to limit the download to selected run folders.

Prerequisites
~~~~~~~~~~~~~

Ensure ``huggingface_hub`` is installed:

.. code-block:: bash

   pip install huggingface_hub

The script will emit a helpful message if the package is missing.

Usage
~~~~~

From the repository root, run:

.. code-block:: bash

   python download_data.py \
     --repo-id WeiqiWangMath/jax-disk2D-runs \
     --local-dir <your-guild-home-dir> \
     --folders 0a0ae0abd3ad4e758a35b28b0616686a another_run_id

Parameters
~~~~~~~~~~

* ``--repo-id``: The Hugging Face repository ID (e.g., ``WeiqiWangMath/jax-disk2D-runs``)
* ``--local-dir``: Your local Guild home directory where the data should be downloaded
* ``--folders``: (Optional) Specific run folder IDs to download. If omitted, all folders will be downloaded.

The downloaded data will be organized in your Guild home directory structure, making it compatible with the existing Guild AI workflow.
