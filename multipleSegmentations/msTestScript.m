% Script to run tests after data is pre-computed

LOAD = 1;

ncv = 1; % number of cross-validation sets
nclasses = 23;

datadir = 'msrc_results/train_results';
% imdir = '~/data/msrc/MSRC_ObjCategImageDatabase_v2/Images/';
outdir = 'msrc_results/test_results';

if LOAD
    load(fullfile(datadir, 'msrc_imsegs.mat'));  %'imsegs'
    load(fullfile(datadir, 'testLabels.mat'));   %'labels' 
    load(fullfile(datadir, 'trainTestFn_tu.mat')); %'test'
    load(fullfile(datadir, 'msClassifiers.mat'));
    load(fullfile(datadir, 'msSegmentFeatures.mat'));
    load(fullfile(datadir, 'msMultipleSegmentations.mat'));    
end


nimages = numel(imsegs);


% disp('Converting labels to superpixels')
% if ~exist('splabels_test', 'var')
%     splabels_test = msLabelMap2Sp(labels, {imsegs.segimage});
%     save(fullfile(outdir, 'msSuperpixelLabelsTest.mat'), 'splabels_test');
% end

disp('Getting accuracy and confusion matrix')
if ~exist('acc', 'var')
    normalize = 0;
    % each pg: # of image segments of an image * # of trained classes
    pg = msTest(imsegs(test), segfeatures(test, :), smaps(test), ...
        labelclassifier, segclassifier, normalize,labels(test));
%     ignore = [5 8];
%     [acc, cm, classcount] = msAnalyzeResult(imsegs(test), labels(test), pg, 0, ignore);
%     cm(ignore, :) = []; cm(:, ignore) = [];        
%     save(fullfile(outdir, 'msResult_tu_tmp.mat'), 'acc', 'cm', 'pg', 'testind', 'classcount', 'ignore');
    
    [acc, cm, classcount] = msAnalyzeResult(imsegs(test), labels(test), pg, 0, []);    
    save(fullfile(outdir, 'msResult_tu_tmp.mat'), 'acc', 'cm', 'pg', 'test', 'classcount');
    disp(['Accuracy: ' num2str(acc)])
%     showConfusionMatrix(cm, classnames(setdiff(2:24, ignore+1)), 1)
end
