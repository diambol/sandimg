clear

thold = 4;
figure
initmax = 10;
imsize = 4;

nhoodsize = 3;
nhoodsize2 = (nhoodsize-1)/2;
%  imin = imread('/Users/Khan/Documents/fr.png');

imin = zeros(50,50);

% imin(1000,1000) = 10000000;
% imin(241:260,250) = floor(rand(20,20)*(thold+1))*1000;
%  imin(100,95:105)=100000;
%  imin(25,25)=100000;
 
 
%  imin0 = imread('C:\Users\Dmitry\Desktop\aiw.jpeg'); 
%  imin0 = imresize(imin0,.5);
% imin0= imin0(100:300,100:300,:);
% imin0 = double(imin0);
% imin0 = sum(imin0.^2,3).^.5;
% 
% 


imin = zeros(imsize,imsize);


%imin(floor(imsize/2)-10:floor(imsize/2)+10,floor(imsize/2)-10:floor(imsize/2)+10)=10;
imin(floor(imsize/2),floor(imsize/2))=1000000;


% imin = randi(10,imsize,imsize);


iniminds = [1:imsize^2];
imin_notempty = iniminds * logical(imin(:));



% imin(900:1100,900:1100)=imin0;
% imin(900:1100,1000)=100000;

% imin = zeros(2000,2000);
%imin(1000,1000)=1000000;
% imin = imin/max(imin(:));
[immag, imdir]=imgradient((imin));
[imx,imy]=imgradientxy(imin);
imdirsin = sind(imdir);
imdircos = cosd(imdir);

immaxdir0 = abs(sind(imdir))==(max(abs(sind(imdir)),abs(cosd(imdir))));
immaxdir=(immaxdir0.*imdirsin + (~immaxdir0).*imdircos);

immaxdirsign = sign(imdirsin).*immaxdir0 + sign(imdircos).*(~immaxdir0);

m1=(max(abs(sind(imdir)),abs(cosd(imdir))));
m1mask = abs(sind(imdir)) == m1;


ex2 = abs(sind(imdir))==(max(abs(sind(imdir)),abs(cosd(imdir))));

ex3=ex2.*(sind(imdir)) + (~ex2).*sign(cosd(imdir));

sizex = size(imin,1);
sizey = size(imin,2);

nhoodsize = 3;
nhoodsize2 = (nhoodsize-1)/2;

ctrdir = 1;

x = [-1 : 1/nhoodsize2  : 1];
kernely = (x*1i)'.* ones(1,nhoodsize);
kernelx = x.* ones(1,nhoodsize)';
vectorkernel = kernely+kernelx;
imindiff = [];
imindiff2 = zeros(size(imin)-nhoodsize2*2);
imindiffcomplex = [];



imgsnapshot=0;

%  img = gpuArray(imin);
 img = (imin);

nsteps = 100000;
stepctr =0;
% for stepctr = 1:nsteps
tic
while 1
    
    stepctr = stepctr+1;
    
    
    
    
    while 1
        
        
     randpix = randi(imsize-2,2,1)+1;

    if img(randpix(1),randpix(2)) >=4
        break
    end
     
    end
    
    
    
    if sum(randpix==2) || sum(randpix==imsize-1)
       
%         disp('.')
        
        imsize = imsize+2;
        
%         tmp = gpuArray(zeros(imsize,imsize));
        tmp = (zeros(imsize,imsize));
%         tmp((floor(imsize/4)+1):floor(3*imsize/4),(floor(imsize/4)+1):floor(3*imsize/4))=img;        
        tmp(2:end-1,2:end-1)=img;        
        img = tmp;
    end
        
     
%     randpixind = sub2ind([imsize,imsize],randpix(2),randpix(2));
%     
%     [a,b]=ind2sub([imsize,imsize],iminrandind)
%     
    
if img(randpix(1),randpix(2)) >= 4
    
    img(randpix(1)-1,randpix(2)) = img(randpix(1)-1,randpix(2))+1;
    img(randpix(1)+1,randpix(2)) = img(randpix(1)+1,randpix(2))+1;
    img(randpix(1),randpix(2)-1) = img(randpix(1),randpix(2)-1)+1;
    img(randpix(1),randpix(2)+1) = img(randpix(1),randpix(2)+1)+1;
    
    img(randpix(1),randpix(2))=img(randpix(1),randpix(2))-4;
    
else
    
%     img(randpix(1),randpix(2))=img(randpix(1),randpix(2))+1;
    
end



if ~mod(stepctr,10000)
toc
%     if ~sum(img(:)~=imgsnapshot(:))
%     break
%     
%     end
    imgsnapshot = img;%load here
%imagesc(log(img));
% imagesc(log(abs(img)).*sign(img));
imagesc(min(img,5));
%  hist(img(:))
drawnow

tic

end

end
% 
[maximindiff,maximdirind] = max(imindiff,[],3);
tholdmask = maximindiff>=thold;
% == abs(real(imindiff))

disp('.');




