function ReadMncToLabel(path,output,output_gt,bias)
if nargin<4
    bias = 0;
end

%bias parameters
%%%%%%%%%%%%%%%%%%%%%%%%%
ncoil = 1;
ns = [0,0];
maxs = 1.2;
mins = 0.3;

%%%%%%%%%%%%%%%%%%%%%%%%%

filename = dir([path,'/','*.mnc']);
range = 75:125;
%types = {'bck_v','fat_v','skull_v','muscles_v'};
type_intensity = [70,46,23];
offsetx = (127.75+(-90.75))+1;

offsety = (145.75+(-126.75))+1;
wx = 256;
wy = 256;
wz = 181;
nsubjects = length(filename)/2;
labels = [];
images = [];
for subindex = 1:nsubjects
    
    
     label = zeros(256,256,181);
     image = zeros(256,256,181);
    for fileindex = 1:2
        current_filename =[path,'/', filename((subindex-1)*2+fileindex).name];
        %load labeled image
        istype = strfind(current_filename,'crisp_v');
        if ~isempty(istype)
             [imaVOL,~] = loadminc(current_filename);
             templabel = zeros(size(imaVOL));
             for typeindex = 1:length(type_intensity)
                 templabel(imaVOL==type_intensity(typeindex)) = typeindex;                 
             end
             yrange = 2:2:min(434,(wy-offsety)*2+1);
             xrange = 2:2:min(362,(wx-offsetx)*2+1);
             
             label(offsety:offsety+length(yrange)-1,offsetx:offsetx+length(xrange)-1,:) = templabel(yrange,xrange,1:2:end);
        end
        %load real image
        istype = strfind(current_filename,'t1w');
        if ~isempty(istype)
             [imaVOL,~] = loadminc(current_filename);
             maxv = max(max(max(imaVOL)));
             image = (double(imaVOL)./maxv);
             
        end
    end
   if bias
        for level = 1:size(image,3)
            ftrue = image(:,:,level);
            [sX, sY] = size(ftrue);
            smap = mri_sensemap_sim('nx', sX, 'ny', sY, 'dx', 192/sX, ...
        'ncoil', ncoil, 'orbit', 90*ncoil, 'rcoil', 100);
            if ncoil == 4, smap = smap(:,:,[4 1 3 2]);end
            %smap = smap ./ max(max(max(abs(smap))));
            smap_max = max(max(max(abs(smap))));
            smap = mins+smap./smap_max.*(maxs-mins);
            

            bcoilI = ftrue + ns(1) * (randn(size(ftrue)) + 1i * randn(size(ftrue)));
            lcoilI = smap .* repmat(ftrue, [1 1 ncoil]) + ns(2) * ...
                (randn(size(smap)) + 1i * randn(size(smap)));
            %normalize
            lcoilI = lcoilI./max(max(max(lcoilI)));
           
            image(:,:,level) = abs(lcoilI(:,:,1));
        end

    end
    image = uint8(round(image.*255));
    %imagesc(image(:,:,100)),colormap gray;
    %mask the image
    image(label==0) = 0;
    temp = cell(1,181);
    for i=1:181
        temp{i} = label(:,:,i);
    end
    label = temp(1,range);
    %generate color coded label groundtruth image
    for i = 1:length(range)
        label_image = msrcLabel2Img( label{i});
        ppmfile = sprintf('gt_%02d_%04d.ppm',subindex,i);
        ppmfile = [output_gt,'/',ppmfile];
        imwrite(label_image,ppmfile,'PPM');
    end
    
    temp = cell(1,181);
    %same masked image to ppm, for segment input
    for i=1:181
        channel = zeros(wy,wx,3);
        channel(:,:,1) = image(:,:,i);
        channel(:,:,2) = image(:,:,i);
        channel(:,:,3) = image(:,:,i);      
        temp{i} = uint8(channel);    
    end
    image = temp(1,range);
    for i = 1:length(image)
       
        ppmfile = sprintf('%02d_%04d.ppm',subindex,i);
        ppmfile = [output,'/',ppmfile];
        imwrite(image{i},ppmfile,'PPM');
    end
    
    %same color coded label ground truth image
    
    
    labels = [labels,label];
    images = [images,image];
    
    
end

save([output,'/','train_data.mat'],'images','labels');
