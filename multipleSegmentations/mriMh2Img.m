function mriMh2Img( imsegs, labels, smaps, nsegall, mhdir )
%MRIMH2IMG Summary of this function goes here
%   given generated multiple hypothesis for an image, visualize all they
%   hypothesis

%   input:
%       imsegs: SINGLE image oversegments by Felzenzswalb
%       labels: mat of labels for the image, for background mask
%       smaps: mat of generated multiple hypothesis (#imasegs.nseg x numel(nsegall))
%       nsegall: vector of all possible target # of segments
%       mhdir: directory for storing multiple hypothesis images
assert(numel(imsegs)==1);

seg = imsegs.segimage;
for mh_ind = 1:1:numel(nsegall)
    visualize_mh=zeros(size(seg,1),size(seg,2));
    for i=1:1:imsegs.nseg
        seglabel=smaps(i, mh_ind); 
        visualize_mh(seg==i)=seglabel;
    end
    nseg = max(smaps(:,mh_ind));
    mh_image = msrcLabel2RdImg( visualize_mh, nseg);
    [~,name,ext] = fileparts(imsegs.imname);
    
    for channel = 1:3
        channel1 = mh_image(:,:,channel);
        channel1(labels==0) = 0;
        mh_image(:,:,channel) = channel1;
    end
    
    imwrite(mh_image,[mhdir , '/' name '_mh_' num2str(nseg) ext]);
end

