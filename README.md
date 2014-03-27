EECS556_code
=======

# Introduction
There are three parts in `code/` folder:

...**CODE/TOOLS**: 
...`Geometric Context/` `multipleSegmentations/`: Hoiem’s segmentation training and testing codes
...`segment/`: Felzenzswalb’s oversegmentation tool
...`trainDataGeneration/`: Our own training data aruto-extraction tool given `ModelNumber_TissueType.mnc.gz` from `EECS556/BrainModels`
**DATASET**: 
...`Brainweb_MRIDatabase`: MRI dataset
...`MSRC_ObjCategImageDatabase_v2`: MSRC dataset (Hoiem used)
**RESULTS**:
...trained classifiers; test results (accuracy and labeled test images);
…`mri_results/`: results for MRI dataset
…`msrc_results/`: results for MSRC dataset

#Usage
1. In Matlab, navigate to `EECS556/code`; run
…`addpath(genpath(‘.’))`
2. Manually unzip  the `ModelNumber_TissueType.mnc.gz` into `Brainweb_MRIDatabase/WebDownloads`, then run
…`get_data_ready`
...which will automatically generate original images in `.ppm` format, and ground truth labels `train_data.mat` in folder `Brainweb_MRIDatabase/Images`.
3.  run `mriTrain`, classifiers are learned and stored in `mri_results/train_results`
...Parameters that can be changed: 
...`train`: training images indicies
...‘test’: test iamges indicies
...‘trainind1’: training images for edge classifer
4. run `mriTestScript`, test images will be loaded and labeld based on learned classifiers. Test results are stored in `mri_results/test_results`
