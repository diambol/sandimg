clear

thold = 4;
figure
initmax = 10;

nhoodsize = 3;
nhoodsize2 = (nhoodsize-1)/2;
% imin = imread('/Users/Khan/Documents/fr.png');

imin = zeros(50,50);

% imin(1000,1000) = 10000000;
% imin(241:260,250) = floor(rand(20,20)*(thold+1))*1000;
%  imin(100,95:105)=100000;
 imin(25,25)=100000;
 
 
 imin0 = imread('C:\Users\Dmitry\Desktop\aiw.jpeg');
 
 imin0 = imresize(imin0,.5);
 
imin0= imin0(100:300,100:300,:);


imin0 = double(imin0);
imin0 = sum(imin0.^2,3).^.5;




imin = zeros(2000,2000);


% imin(900:1100,900:1100)=imin0;
imin(900:1100,1000)=100000;

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

 img = gpuArray(imin);

nsteps = 100000;
stepctr =0;
% for stepctr = 1:nsteps
while 1
    stepctr = stepctr+1;
tholdmask = img>=thold;
imgtmp = img;

for ctrx = -nhoodsize2:nhoodsize2
    
    
    for ctry = -nhoodsize2:nhoodsize2
        
%         if ~(ctrx == 0 && ctry == 0  )
        if (abs(ctrx) +  abs(ctry) == 1  )
%         if ~(ctrx==0 && ctry==0)
     imgtmp((2+ctrx):(end-nhoodsize2+ctrx),(2+ctry):(end-nhoodsize2+ctry)) = ...
      imgtmp((2+ctrx):(end-nhoodsize2+ctrx),(2+ctry):(end-nhoodsize2+ctry)) +...
         tholdmask((1+nhoodsize2):(end-nhoodsize2),(1+nhoodsize2):(end-nhoodsize2));
     
          
        
        end
    end
end

imgtmp = imgtmp - tholdmask*thold;


img = imgtmp;


if ~mod(stepctr,2000)

    if ~sum(img(:)~=imgsnapshot(:))
    break
    
    end
    imgsnapshot = img;%load here
%imagesc(log(img));
% imagesc(log(abs(img)).*sign(img));
imagesc(min(img,5));
%  hist(img(:))
drawnow



end

end
% 
[maximindiff,maximdirind] = max(imindiff,[],3);
tholdmask = maximindiff>=thold;
% == abs(real(imindiff))

disp('.');




