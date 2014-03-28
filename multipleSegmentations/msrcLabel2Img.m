function label_image = msrcLabel2Img( label )
%MCRCLABEL2IMG Summary of this function goes here
%   input:  labels found from trained classifiers for an MSRC dataset test image
%   output: corresponding label image w*h*3 (RGB image cooresponds to the same colorcode of training image in MSRC)

% reference: MSRC_ObjCategImageDatabase_v2/ClickMe.html
% [0 0 0] for void or unlabled

label_image = zeros(size(label,1), size(label,2));
label_r = zeros(size(label,1), size(label,2));
label_g = zeros(size(label,1), size(label,2));
label_b = zeros(size(label,1), size(label,2));
for i=1:1:23
    class_ind = label==i;
    class_color = color_msrc(i);
    label_r(class_ind) = class_color(1);
    label_g(class_ind) = class_color(2);
    label_b(class_ind) = class_color(3);
    label_image(:,:,1) = label_r;
    label_image(:,:,2) = label_g;
    label_image(:,:,3) = label_b;
end

label_image=uint8(label_image);
end

function class_color=color_msrc(label)

switch label
    case 1
        class_color=[128 0 0];
    case 2
        class_color=[0 128 0];
    case 3
        class_color=[128 128 0];
    case 4
        class_color=[0 0 128];
    case 5
        class_color=[128 0 128];
    case 6
        class_color=[0 128 128];
    case 7
        class_color=[128 128 128];
    case 8
        class_color=[64 0 0];
    case 9
        class_color=[192 0 0];
    case 10
        class_color=[64 128 0];
    case 11
        class_color=[192 128 0];
    case 12
        class_color=[64 0 128];
    case 13
        class_color=[192 0 128];
    case 14
        class_color=[64 128 128];
    case 15
        class_color=[192 128 128];
    case 16
        class_color=[0 64 0];
    case 17
        class_color=[128 64 0];
    case 18
        class_color=[0 192 0];
    case 19
        class_color=[128 64 128];
    case 20
        class_color=[0 192 128];
    case 21
        class_color=[128 192 128];
    case 22
        class_color=[64 64 0];
    case 23
        class_color=[192 64 0];
    otherwise
        error('Error, no corresponding label found!');
end


end

