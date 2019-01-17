.. _cohort:

Pipeline cohort file
====================

A pipeline cohort file defines the experimental sample -- the set of subjects that the pipeline should process.

 The cohort file is formatted as ``.csv`` and contains:

 * A column corresponding to each category of input
 * A header naming each category of input
 * A row corresponding to each subject

Examples
----------

Cohort files can usually be prepared using a simple command-line call. The contents of a cohort
file will vary depending upon:

 * The imaging modality
 * The experimental objective
 * Available inputs

Examples for a few common processing cases are provided below.

Subject identifiers
~~~~~~~~~~~~~~~~~~~~

In general, all cohort files should contain a unique set of identifier variables for each unique
subject. The pipeline system uses identifier variables to generate a unique output path for each
input. To cast a cohort field as an identifier, give it the name ``id<i>`` in the cohort header,
where ``<i>`` is a nonnegative integer. In the illustrative example, ``id0`` might correspond to
the subject's identifier, ``id1`` to the time point (as in a longitudinal study). So
``sub-01,ses-01`` would denote the first session for subject 001. Note that these do not get
automatically added to paths when xcp is looking for files.::

  id0,id1
  sub-01,ses-01
  sub-01,ses-02
  sub-02,ses-01
  sub-03,ses-01
  sub-03,ses-02
  sub-04,ses-02
  sub-04,ses-01

Guidelines and specifications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 * There are no upper or lower limits to the number of identifier variables that can be provided,
   but in general it is recommended that they be ordered hierarchically. That is, subject should
   precede time point and not the other way around.
 * Identifiers can comprise any combination of alphanumeric characters and underscores. Any other
   characters should be excised or mapped to the set of valid characters.

Path definitions
~~~~~~~~~~~~~~~~~~

Paths defined in a cohort file can be specified either as absolute paths or as relative paths. For
portability, relative path definitions are recommended where possible. If relative paths are
provided, then the call to ``xcpEngine`` should include the ``-r`` flag, which accepts as its
argument the path relative to which cohort paths were defined. For instance, the provided example
would yield a value of
``/data/example/derivatives/fmriprep/sub-01/ses-01/anat/sub-01_ses-01_desc-preproc_T1w.nii.gz`` for
``img``.::

  -r /data/example/derivatives/fmriprep

with::

  id0,id1,img
  sub-01,ses-01,sub-01/ses-01/anat/sub-01_ses-01_desc-preproc_T1w.nii.gz


This is particularly useful for using directories mounted in Singularity.

Anatomical processing
~~~~~~~~~~~~~~~~~~~~~~

For anatomical processing, the cohort file is quite minimal: only the subject's anatomical image is
required in addition to the set of identifiers. The subject's anatomical image should receive the
header ``img``. **Anatomical processing must occur after ``FMRIPREP`` and before functional
processing**.::

  id0,id1,img
  sub-01,ses-01,sub-01/ses-01/anat/sub-01_ses-01_desc-preproc_T1w.nii.gz
  sub-01,ses-02,sub-01/ses-02/anat/sub-01_ses-02_desc-preproc_T1w.nii.gz
  sub-02,ses-01,sub-02/ses-01/anat/sub-02_ses-01_desc-preproc_T1w.nii.gz
  sub-03,ses-01,sub-03/ses-01/anat/sub-03_ses-01_desc-preproc_T1w.nii.gz


There are some important differences in what analyses can be run depending on whether you specify
an MNI-normalized structural image or a native space T1w image.

Functional processing
~~~~~~~~~~~~~~~~~~~~~~~

There are two ways that the cohort file for the functional processing stream can be specified. In
the case where the T1w-space output from `FMRIPREP` (requires that `--output-spaces` included `T1w`
in your `FMRIPREP` call) was processed with the XCP anatomical stream, you need to specify the
directory where that output exists. An example cohort file for this use case would look like::

  id0,id1,img,antsct
  sub-01,ses-01,sub-01/ses-01/func/sub-01_ses-01_task-rest_space-T1w_desc-preproc_bold.nii.gz,xcp_output/sub-01/ses-01/struc
  sub-01,ses-02,sub-01/ses-02/func/sub-01_ses-02_task-rest_space-T1w_desc-preproc_bold.nii.gz,xcp_output/sub-01/ses-02/struc
  sub-02,ses-01,sub-01/ses-01/func/sub-02_ses-01_task-rest_space-T1w_desc-preproc_bold.nii.gz,xcp_output/sub-02/ses-01/struc
  sub-03,ses-01,sub-03/ses-01/func/sub-03_ses-01_task-rest_space-T1w_desc-preproc_bold.nii.gz,xcp_output/sub-03/ses-01/struc


The first line of this cohort file would process the image
``${DATA_ROOT}/sub-01/ses-01/func/sub-01_ses-01_task-rest_space-T1w_desc-preproc_bold.nii.gz``.


Subject variables
------------------

Each of the columns in the cohort file becomes a *subject variable* at runtime. Subject variables
can be used in the design_ to assign a parameter
subject-specific values. For instance, the ``coreg_segmentation`` parameter in the :ref:`coreg`
can be assigned the ``segmentation`` subject variable. To
indicate that the assignment is a subject variable, include the array index ``[sub]`` in the
variable's name as shown.::

  coreg_segmentation[2]=${segmentation[sub]}