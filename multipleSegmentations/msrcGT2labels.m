function label_image = msrcGT2labels( gt_image )
%MSRCGT2LABELS Summary of this function goes here
%   input:  MSRC dataset GT (grouth truch) images w*h*3 (RGB image)
%   output: corresponding label image w*h*1 (intensity image)

% reference: MSRC_ObjCategImageDatabase_v2/ClickMe.html
% 0 for void or unlabled

label_image = zeros(size(gt_image,1), size(gt_image,2));

label_image(gt_image(:,:,1)==128 & gt_image(:,:,2)==0 & gt_image(:,:,3)==0)=1; % [128 0 0]
label_image(gt_image(:,:,1)==0 & gt_image(:,:,2)==128 & gt_image(:,:,3)==0)=2; % [0 128 0]
label_image(gt_image(:,:,1)==128 & gt_image(:,:,2)==128 & gt_image(:,:,3)==0)=3; % [128 128 0]
label_image(gt_image(:,:,1)==0 & gt_image(:,:,2)==0 & gt_image(:,:,3)==128)=4; % [0 0 128]
label_image(gt_image(:,:,1)==128 & gt_image(:,:,2)==0 & gt_image(:,:,3)==128)=5; % [128 0 128]
label_image(gt_image(:,:,1)==0 & gt_image(:,:,2)==128 & gt_image(:,:,3)==128)=6; % [0 128 128]
label_image(gt_image(:,:,1)==128 & gt_image(:,:,2)==128 & gt_image(:,:,3)==128)=7; % [128 128 128]
label_image(gt_image(:,:,1)==64 & gt_image(:,:,2)==0 & gt_image(:,:,3)==0)=8; % [64 0 0]
label_image(gt_image(:,:,1)==192 & gt_image(:,:,2)==0 & gt_image(:,:,3)==0)=9; % [192 0 0]
label_image(gt_image(:,:,1)==64 & gt_image(:,:,2)==128 & gt_image(:,:,3)==0)=10; % [64 128 0]
label_image(gt_image(:,:,1)==192 & gt_image(:,:,2)==128 & gt_image(:,:,3)==0)=11; % [192 128 0]
label_image(gt_image(:,:,1)==64 & gt_image(:,:,2)==0 & gt_image(:,:,3)==128)=12; % [64 0 128]
label_image(gt_image(:,:,1)==192 & gt_image(:,:,2)==0 & gt_image(:,:,3)==128)=13; % [192 0 128]
label_image(gt_image(:,:,1)==64 & gt_image(:,:,2)==128 & gt_image(:,:,3)==128)=14; % [64 128 128]
label_image(gt_image(:,:,1)==192 & gt_image(:,:,2)==128 & gt_image(:,:,3)==128)=15; % [192 128 128]
label_image(gt_image(:,:,1)==0 & gt_image(:,:,2)==64 & gt_image(:,:,3)==0)=16; % [0 64 0]
label_image(gt_image(:,:,1)==128 & gt_image(:,:,2)==64 & gt_image(:,:,3)==0)=17; % [128 64 0]
label_image(gt_image(:,:,1)==0 & gt_image(:,:,2)==192 & gt_image(:,:,3)==0)=18; % [0 192 0]
label_image(gt_image(:,:,1)==128 & gt_image(:,:,2)==64 & gt_image(:,:,3)==128)=19; % [128 64 128]
label_image(gt_image(:,:,1)==0 & gt_image(:,:,2)==192 & gt_image(:,:,3)==128)=20; % [0 192 128]
label_image(gt_image(:,:,1)==128 & gt_image(:,:,2)==192 & gt_image(:,:,3)==128)=21; % [128 192 128]
label_image(gt_image(:,:,1)==64 & gt_image(:,:,2)==64 & gt_image(:,:,3)==0)=22; % [64 64 0]
label_image(gt_image(:,:,1)==192 & gt_image(:,:,2)==64 & gt_image(:,:,3)==0)=23; % [192 64 0]

% for i=1:size(gt_image,1)
%     for j=1:size(gt_image,2)
%         switch mat2str(squeeze(gt_image(i,j,:)))
%             case mat2str([0 0 0]')
%                 label_image(i,j)=0;
%             case mat2str([128 0 0]')
%                 label_image(i,j)=1;
%             case mat2str([0 128 0]')
%                 label_image(i,j)=2;
%             case mat2str([128 128 0]')
%                 label_image(i,j)=3;
%             case mat2str([0 0 128]')
%                 label_image(i,j)=4;
%             case mat2str([128 0 128]')
%                 label_image(i,j)=5;
%             case mat2str([0 128 128]')
%                 label_image(i,j)=6;
%             case mat2str([128 128 128]')
%                 label_image(i,j)=7;
%             case mat2str([64 0 0]')
%                 label_image(i,j)=8;
%             case mat2str([192 0 0]')
%                 label_image(i,j)=9;
%             case mat2str([64 128 0]')
%                 label_image(i,j)=10;
%             case mat2str([192 128 0]')
%                 label_image(i,j)=11;
%             case mat2str([64 0 128]')
%                 label_image(i,j)=12;
%             case mat2str([192 0 128]')
%                 label_image(i,j)=13;
%             case mat2str([64 128 128]')
%                 label_image(i,j)=14;
%             case mat2str([192 128 128]')
%                 label_image(i,j)=15;
%             case mat2str([0 64 0]')
%                 label_image(i,j)=16;
%             case mat2str([128 64 0]')
%                 label_image(i,j)=17;
%             case mat2str([0 192 0]')
%                 label_image(i,j)=18;
%             case mat2str([128 64 128]')
%                 label_image(i,j)=19;
%             case mat2str([0 192 128]')
%                 label_image(i,j)=20;
%             case mat2str([128 192 128]')
%                 label_image(i,j)=21;
%             case mat2str([64 64 0]')
%                 label_image(i,j)=22;
%             case mat2str([192 64 0]')
%                 label_image(i,j)=23;
%             otherwise
%                 error('Error, no corresponding label found!');
%         end
%     end
% end



end

