mri_imdir = 'Brainweb_MRIDatabase/WebDownloads';
train_images_imdir = 'Brainweb_MRIDatabase/Images';
train_gt_imdir = 'Brainweb_MRIDatabase/Groundtruth';
ReadMncToLabel(mri_imdir, train_images_imdir, train_gt_imdir,1);