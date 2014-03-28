mri_imdir = 'Brainweb_MRIDatabase/WebDownloads';
train_images_imdir = 'Brainweb_MRIDatabase/Images';
train_gt_imdir = 'Brainweb_MRIDatabase/Groundtruth';
rmfile = ['rm ',pwd,'/',train_images_imdir,'/*ppm'];
system(rmfile);
rmfile = ['rm ',pwd,'/',train_gt_imdir,'/*ppm'];
system(rmfile);
ReadMncToLabel(mri_imdir, train_images_imdir, train_gt_imdir,1);