EECS556_code
=======

# Introduction
There are three parts in `code/` folder:

1. **CODE/TOOLS** 
 * `Geometric Context/` and `multipleSegmentations/` <br /> 
    Hoiem’s segmentation training and testing codes
 * `segment/` <br /> 
    Felzenzswalb’s oversegmentation tool
 * `trainDataGeneration/` <br /> 
    Our own training data aruto-extraction tool given `ModelNumber_TissueType.mnc.gz` from `EECS556/BrainModels`
2. **DATASET**
 * `Brainweb_MRIDatabase`/ MRI dataset
 * `MSRC_ObjCategImageDatabase_v2/` MSRC dataset (Hoiem used)
3. **RESULTS** <br /> 
    trained classifiers; test results (accuracy and labeled test images);
 * `mri_results/` results for MRI dataset
 * `msrc_results/` results for MSRC dataset

#Usage
1. In Matlab, navigate to `EECS556/code`; run
```
>> addpath(genpath(‘.’))
```
2. Manually unzip  the `ModelNumber_TissueType.mnc.gz` into `Brainweb_MRIDatabase/WebDownloads`, then run <br />
    `get_data_ready` <br /> 
    which will automatically generate original images in .ppm format, and ground truth labels `train_data.mat` in folder `Brainweb_MRIDatabase/Images`.
3.  Run `mriTrain`, classifiers are learned and stored in `mri_results/train_results`
4. run `mriTestScript`, test images will be loaded and labeld based on learned classifiers. <br />
    Test results are stored in `mri_results/test_results`

#Parameters
Parameters that can be tuned: <br /> 
    `train`: training images indicies <br /> 
    `test`: test iamges indicies <br /> 
    `trainind1`: training images for edge classifer <br /> 
    `sigma`: Used to smooth the input image before segmenting it (0.1) <br />
    `k`: Value for the threshold function (100) <br /> 
    `min`: Minimum component size enforced by post-processing (5) 

#Troubleshooting
1. Complain about treevalc, try navigate to Geometric/
    
