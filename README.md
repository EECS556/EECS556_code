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
1. In Matlab, navigate to `EECS556/code`; Run

        >> addpath(genpath(‘.’))
2. Manually unzip  the `ModelNumber_TissueType.mnc.gz` into `Brainweb_MRIDatabase/WebDownloads`, then run

        >> get_data_ready
 which will automatically generate original images in .ppm format, and ground truth labels `train_data.mat` in folder `Brainweb_MRIDatabase/Images`. <br />
3.  Run 

        >> mriTrain
    classifiers are learned and stored in `mri_results/train_results`
4. run 

        >> mriTestScript
    test images will be loaded and labeld based on learned classifiers. <br />
    Test results are stored in `mri_results/test_results`

#Parameters
Parameters that can be tuned: <br /> 
    `ncv`: nvc-fold cross-validation
    `nsegments`: list of number of regions for multiple hypothesis
    `train`: training images indicies <br /> 
    `test`: test iamges indicies <br /> 
    `trainind1`: training images for edge classifer <br /> 
    `sigma`: Used to smooth the input image before segmenting it (0.1) <br />
    `k`: Value for the threshold function (100) <br /> 
    `min`: Minimum component size enforced by post-processing (5) 

#Troubleshooting
1. Complain about treevalc, try navigate to `GeometricContext/src/boosting` and then

        >> mex treevalc
2. Complain about image file not exist, such as 

		File "./tmpimsp424511.ppm" does not exist.
	
		Error in processSuperpixelImage (line 24)
    		im = imread(fn{f});
	
		Error in msCreateSuperpixels (line 12)
		imsegs = processSuperpixelImage(outfn);
	try
	
		cd EECS556_code/segment/
		rm segment
		make
	and test whether `segment` works by
	
		./segment 0.1 100 5 test_in.ppm test_out.ppm
	

#Git Clone Repository Instructions
If you have not generated any SSH key for github on your machine, please do so following this [tutorial](https://help.github.com/articles/generating-ssh-keys)

1. Create a new folder for the repository you are going to clone, and navigate into the folder, eg

		$  mkdir EECS556_code
		$  cd EECS556_code/
2. Set up git
		
		$  git remote add origin SSH
		$  git pull origin master
	where `SSH` is the SSH clone URL shown on the github repository webpage (near the bottom of the right column, above "Download ZIP").
3. Push to git
	After you commit any changes, push to git

		$  git push origin master



