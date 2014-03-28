% msTrain
clear all;
size_of_test = 95;

nsegments = [5 7 10 15 20 25 35 50 60 70 80 90 100 Inf]; % number of segments per segmentation
ncv = 1; % number of cross-validation sets (typically 1)
labeltol = 0.9; % required percentage of single-label pixels for segment to be good (default 0.9)
nclasses = 3;  % number of categories

imdir = 'Brainweb_MRIDatabase/Images/';  % where the training/test images are stored
outdir = 'mri_results/train_results';  % where to save data, results, etc.

% labels is a cell array of pixel maps, with values equal to the category (0 for unlabeled)
% labels: 1xnimages cell array, each cell contains a label map, label map
% is a matrix which gives category labels for each pixel of the
% corresponding image
train_data=load([pwd,'/', imdir, 'train_data.mat']);
labels = train_data.labels;

% train: training images indicies
% test: test iamges indicies
size_of_training  = length(labels);
train=1:size_of_training-size_of_test-1; test=size_of_training-size_of_test:size_of_training;
allind = union(train, test);
trainind1 = train(1:round(train(end)/2));  
trainind = train; % use first 40 training images to train segmentations
trainind2 = setdiff(trainind, trainind1);
testind = test;
save(fullfile(outdir, 'trainTestFn_tu.mat'), 'test');

% imsegs: image segmentations
% create an array of struct imsegs_from_single_image
files = dir( fullfile(imdir,'*.ppm') );   %# list all *.ppm files
files = {files.name}';  
for i=1:1:numel(allind)
    fname = fullfile(imdir,files{allind(i)});     %# full path to file
    im = imread(fname);
    imsegs(i) = msCreateSuperpixels(im, files{allind(i)});
end
save(fullfile(outdir, 'msrc_imsegs.mat'), 'imsegs');

nimages = numel(imsegs);

disp('Converting labels to superpixels')
if ~exist('splabels', 'var')
    splabels = msLabelMap2Sp(labels, {imsegs.segimage});  
    save(fullfile(outdir, 'msSuperpixelLabels.mat'), 'splabels');
    save(fullfile(outdir, 'testLabels.mat'), 'labels');
end

disp('Getting superpixel features')
if ~exist('spfeatures', 'var')
    spfeatures = mcmcGetAllSuperpixelData(imdir, imsegs);
    save(fullfile(outdir, 'msSuperpixelData.mat'), 'spfeatures');
end

disp('Getting edge features')
if ~exist('efeatures', 'var')
    [efeatures, adjlist] = mcmcGetAllEdgeData(spfeatures, imsegs);
    save(fullfile(outdir, 'msEdgeData.mat'), 'efeatures', 'adjlist');
end

disp('Training edge classifier')
if ~exist('eclassifier', 'var')
    eclassifier = msTrainEdgeClassifier(efeatures(trainind1), ...
        adjlist(trainind1), imsegs(trainind1), splabels(trainind1));
    ecal = msCalibrateEdgeClassifier(efeatures(trainind2), adjlist(trainind2), ...
        imsegs(trainind2), eclassifier, splabels(trainind2), ncv);
    ecal = ecal{1};
    save(fullfile(outdir, 'msEdgeClassifier.mat'), 'eclassifier', 'ecal');
end

disp('Getting multiple segmentations')
if ~exist('smaps', 'var')
    for f = allind       
        pE{f} = test_boosted_dt_mc(eclassifier, efeatures{f});
        pE{f} = 1 ./ (1+exp(ecal(1)*pE{f}+ecal(2)));                
        smaps{f} = msCreateMultipleSegmentations(pE{f}, adjlist{f}, ...
            imsegs(f).nseg, nsegments);
    end
    save(fullfile(outdir, 'msMultipleSegmentations.mat'), 'pE', 'smaps');
end
    
disp('Getting segment features')
if ~exist('segfeatures', 'var')    
    for f = allind       
        if mod(f, 50)==0, disp(num2str(f)), end
        im = im2double(imread([imdir '/' imsegs(f).imname]));
        imdata = mcmcComputeImageData(im, imsegs(f));
    
        for k = 1:numel(nsegments)
            segfeatures{f, k} = mcmcGetSegmentFeatures(imsegs(f), ...
                spfeatures{f}, imdata, smaps{f}(:, k), (1:max(smaps{f}(:, k))));
            [mclab{f, k}, mcprc{f, k}, allprc{f, k}, trainw{f, k}] = ...
                msSegs2labels(imsegs(f), smaps{f}(:, k), splabels{f}, nclasses);
            seglabel{f, k} = mclab{f, k}.*(mcprc{f, k}>labeltol);
            seggood{f,k} =  1*(mcprc{f, k}>labeltol) + (-1)*(mcprc{f, k}<labeltol); 
        end    
    end 
    save(fullfile(outdir, 'msSegmentFeatures.mat'), 'segfeatures', 'seglabel', 'seggood', 'trainw');
end

disp('Training segmentation classifier')
if ~exist('segclassifier', 'var')
    traindata = segfeatures(trainind, :);
    trainlabels = seggood(trainind, :);
    trainweights = trainw(trainind, :);
    segclassifier = mcmcTrainSegmentationClassifier2(traindata, trainlabels, trainweights); 
    save(fullfile(outdir, 'msSegmentationClassifier.mat'), 'segclassifier');    
end

disp('Training label classifier')
if ~exist('labelclassifier', 'var')
    traindata = segfeatures(trainind, :);
    trainlabels = seglabel(trainind, :);    
    trainweights = trainw(trainind, :);
    labelclassifier = msTrainLabelClassifier(traindata, trainlabels, trainweights, [], Inf);
    %labelclassifier = mcmcTrainSegmentClassifier2(traindata, trainlabels, trainweights); 
    save(fullfile(outdir, 'msLabelClassifier.mat'), 'labelclassifier');    
end
    
save(fullfile(outdir, 'msClassifiers.mat'), 'eclassifier', 'segclassifier', 'labelclassifier', 'ecal');



