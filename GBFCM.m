function [optu optc Mb] = GBFCM(data1,data2,c0,iteration, m, alpha, eps)
clc; clear all;


[nc,ns]=size(c0);

%[nd,ns,ni]=size(data1);  % nd: number of data1 and ns: number of image sequences
[nd,ns]=size(data1); 

% Define matrix
u=zeros(nd,nc);
%optu=zeros(nd,nc,ni);
optu=zeros(nd,nc);


%optc=zeros(nc,ns,ni);
optc=zeros(nc,ns);

Mdata1=zeros(nd,nc,ns);  % data1 matrix
Mdata2=zeros(nd,nc,ns);
% will this change something
Mb = ones(nd,nc,ns); %bias field matrix
Mc=zeros(nd,nc,ns);  % cluster matrix
diff1=zeros(nd,nc,ns); % diff matrix 
diff2=zeros(nd,nc,ns);  % diff matrix
Ms = zeros(size(mask));
Ms = Ms*nan;
% Start interation
%for p=1:ni  % work on one slice each time   
    for i=1:ns
        Mdata1(:,:,i)=data1(:,i)*ones(1,nc); % 2D matrix to 3D matrix
        Mdata2(:,:,i)=data2(:,i)*ones(1,nc); % 2D matrix to 3D matrix
        Mc(:,:,i)=ones(nd,1)*c0(:,i)'; % 2D matrix to 3D matrix
    end
    newc = Mc;
    %{
    % Alternative way: need to check the accuracy and speed later
    Mdata1=shiftdim(repmat(data1(:,:)',[1,1,nc]),1);
    Mdata2=shiftdim(repmat(data2(:,:)',[1,1,nc]),1);
    Mc=repmat(shiftdim(c0,-1),[nd,1,1]);
    %}
    
    k=1;
    result = zeros(iteration,1);
    result2 = zeros(iteration,1);
    result3 = result2;
    while k < iteration+1
        if k==1
            disp('Start GBFCM_s Fuzzy Optimization!');
        elseif rem(k,10)==0
            text=sprintf('Iteration: %s',num2str(k));
            disp(text);
        end
        if rem(k,100)==0           
            disp('breakpoint');
        end
        
        diff1 = e_dis(Mdata1-Mb,Mc);
	    diff2 = e_dis(Mdata2-Mb,Mc);

        %calculate membership
        magsquare1=sum(diff1,3); 
        magsquare2 = sum(diff2,3);
        
        un=(magsquare1+alpha*(magsquare2)).^(-1/(m-1));
        ud=repmat(sum((magsquare1+alpha*(magsquare2)).^(-1/(m-1)),2),[1,nc]);
        
        u=un./ud;
        %u = ud./un;
        if any(isnan(u(:)))
            [index1,index2]=find(isnan(u));
            disp('Find nan in u');
            u(index1,:)=0;
            id = (index2-1)*size(u,1)+index1;
            u(id)=1;
        end
        
        test = sum(u,2);
        if ~isempty(find(test>1.5))
            disp('more than one nan');
            break
        end
        
        normalize = repmat(sum(u,2),[1,nc]);
        u = u./normalize;
        if any(isinf(u(:)))
            [index1,index2]=find(isinf(u));
            disp('Find inf in u');
            u(index1,:)=0;
            id = (index2-1)*size(u,1)+index1;
            u(id)=1;
        end
        
        um=u.^m;
        
        
        
        newcn(1,:,:) = sum(repmat(um,[1,1,ns]).*((Mdata1-Mb)+ alpha.*(Mdata2-Mb)),1);
        newcd(1,:,:) = sum(repmat(um,[1,1,ns]).*(1+ alpha*1),1);
        newc(1,:,:) = newcn(1,:,:)./newcd(1,:,:);
        newc=repmat(newc(1,:,:),[nd,1,1]);
        
        
        
          Mbn(:,1,:) = sum(repmat(um,[1,1,ns]).*(1-diff1).*(Mdata1-newc),2);%+alpha*sum(repmat(um,[1,1,ns]).*(1-diff2).*(Mdata2-newc),2);
          Mbd(:,1,:) = sum(repmat(um,[1,1,ns]).*(1-diff1),2);%+alpha*sum(repmat(um,[1,1,ns]).*(1-diff2),2);
%           Mb(:,1,:) = Mbn(:,1,:)./Mbd(:,1,:);
          
%         Regularization using Eucilidean distance    

          Mbn(:,1,1) = sum(Mbn(:,1,:),3);
          %Mbn(:,1,1) = sum(repmat(um,[1,1,ns]).*(Mdata1-newc),2)+sum(repmat(um,[1,1,ns]).*(Mdata1-newc),2);
          %Mbd(:,1,1) = sum(repmat(um,[1,1,ns]).*(1-diff1),2)*2/100+2*gamma;
          Mbd(:,1,1) = sum(Mbd(:,1,:),3);
          Mb(:,1,1) = Mbn(:,1,1)./Mbd(:,1,1);
          dc = mean(Mb(:,1,1));
          Mb(:,1,1) = Mb(:,1,1)-repmat(dc,[size(Mb(:,1,1),1),1,1]);
          
          temp = Mb(:,1,1);
          Ms(mask) = temp;
%           if k<11
%           for id = 1:size(mask,3)
%               Ms(:,:,id) = medfilt2nan(Ms(:,:,id),3);
%               Ms(:,:,id) = medfilt2nan(Ms(:,:,id),3);
%               Ms(:,:,id) = medfilt2nan(Ms(:,:,id),3);
%           end
%           end
          Ms(find(isnan(Ms)))=0;
          Ms(mask) = temp;
          Ms = smoothn(Ms,2000);
          %Ms = log(Ms+1);
          Mb(:,1,1) = Ms(mask);
         
%           scale = sum(sum((Mb(:,1,:).^2)));
%           if scale>0
%               Mb(:,1,:) = Mb(:,1,:)./scale;
%           end
%            scale = max(max(Mb(:,1,:)))-min(min(Mb(:,1,:)));
%            Mb(:,1,:) = Mb(:,1,:)./scale;
           Mb=repmat(Mb(:,1,1),[1,nc,ns]);
          
        %update centroid
        
        

         
%           Regularization using Gaussian distance       
        
          
%         pointset = 1:nd;
%         samplesize = round(0.1*nd);
%         sampledis = round(nd/samplesize);
%         samplepoint = 1:sampledis:nd;
%         samplepoint = [samplepoint,nd];
%         sMb = zeros(nd,ns); 
        
        %update bias field
%         Mbn(:,1,:) = sum(repmat(um,[1,1,ns]).*((1-diff1).*(Mdata1-newc)+ (1-diff2).*(Mdata2-newc)),2);
% 	    Mbd(:,1,:) = sum(repmat(um,[1,1,ns]).*((1-diff1)+ (1-diff2)),2);
%         Mb(:,1,:) = Mbn(:,1,:)./Mbd(:,1,:);
%         
%         for m = 1:ns
%             rMb = Bmap(Mb(:,1,ns));
%             rMb = downsample(rMb,3);
%             rMb = downsample(rMb',3);
%             rMb = rMb';
%             Mb = 
%         end
%         
% %         sMb = reshape(Mb(:,1,:),[nd,ns]);
% %         xx = 1:nd; yy = 1:ns;
% %         [sp, value] = spaps({xx,yy},sMb,1,1);
% %         sMb = value;
% %         sMb = reshape(sMb,[nd,1,ns]);
% %         Mb(:,1,:) = sMb;
%         
% %         for f=1:500
% %         o = Multi_Bmap(Mb,mask);
% %         h = fspecial3('gaussian',[35,35,5]);
% %         o = imfilter(o,h);
% %         end
% %         
% %         Mb(:,1,:) = o(mask);
%         Mb=repmat(Mb(:,1,:),[1,nc,1]); %have problem with dimension
% % 		 
%         result(k,1) = sum(sum(magsquare1.*um))+alpha*sum(sum(magsquare2.*um));
%         result2(k,1) = sum(sum(r1));
%         result3(k,1) = sum(sum(r));
%         if (result2(k,1) ~=0)
%         gamma = result(k,1)/result3(k,1)
%         end
        if max(abs(newc-Mc))<eps | k>iteration-1   % not sure if another condition is needed
           % question: how to avoid a local minimum and get a global minimum?
            optc(:,:)=shiftdim(newc(1,:,:),1)
            optu(:,:)=u;
            disp('Finish Fuzzy Optimization!');
            break
        else
            Mc=newc;  % update cluster center
            k=k+1;   % update interation number
        end
    end
% figure;
% plot(result(1:k));  title('1');
% figure;
% plot(result2(1:k)); title('2');
% figure;
% plot(result3(1:k)); title('3');
% figure;
% plot(result(1:k)+gamma*result3(1:k));
    save('Mb_s.mat','Mb');
    disp('Mb saved!');
    % need to add a code when the iteration is not enough
    % optu: need to reshape in the main code
%end
