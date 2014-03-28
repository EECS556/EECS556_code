function label_image = msrcLabel2RdImg( label, nseg)
%MCRCLABEL2RDIMG Summary of this function goes here
%   input:  
%       label: labels for multiple hypothesis
%       nseg: # of segments generated by multiple hypothesis
%   output: 
%       label_image: corresponding label image w*h*3 (RGB image) with random color

label_image = zeros(size(label,1), size(label,2));
label_r = zeros(size(label,1), size(label,2));
label_g = zeros(size(label,1), size(label,2));
label_b = zeros(size(label,1), size(label,2));

cc= hsv(nseg)*255;
for i=1:1:nseg
    class_ind = label==i;
    class_color = cc(i,:);
    label_r(class_ind) = class_color(1);
    label_g(class_ind) = class_color(2);
    label_b(class_ind) = class_color(3);
    label_image(:,:,1) = label_r;
    label_image(:,:,2) = label_g;
    label_image(:,:,3) = label_b;
end

label_image=uint8(label_image);



end
