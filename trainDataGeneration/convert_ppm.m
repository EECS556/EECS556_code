function convert_ppm(dataset)
dir = 'Brainweb_MRIDatabase/Images';
[n1 n2 n3] = size(dataset);
for i = 1:n3
    rawdata = dataset(:,:,i).*255./max(max(dataset(:,:,i)));
    %rawdata = dataset(:,:,i);
    rawdata = uint8((repmat(rawdata,[1 1 3])));
    
    file = sprintf('%s/%02d_%04d.ppm',dir,2,i);
    imwrite(rawdata,file,'PPM');
end

