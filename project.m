clear all;close all;clc;

% I1 = imread("skull.png");
I1 = imread("fish.png");

% L = mean2(luminance);

[w,h,d] = size(I1);

%offset calculate
summ = zeros(w,h);
for i = 1 : 1 : w
    for j = 1 : 1 : h
        summ(i,j) = min(min(I1(i,j,:)));
        
    end
end

%proposed MSF
 offset = mean2(summ);
 ini_offset = offset;
 MSF = zeros(w,h,d);
 
for i = 1 : 1 : w
    for j = 1 : 1 : h
        if(max(max(I1(i,j,:))) - min(min(I1(i,j,:))) + ini_offset >255)
            n_offset = ini_offsett - ((max(max(I1(i,j,:))) - min(min(I1(i,j,:))) + offset) - 255);
            MSF(i,j,:) = I1(i,j,:) - min(min(I1(i,j,:))) + n_offset;
        end
        if(ini_offset > max(max(I1(i,j,:))))
            n_offset =  max(max(I1(i,j,:)));
            MSF(i,j,:) = I1(i,j,:) - min(min(I1(i,j,:))) + n_offset;
        else
            MSF(i,j,:) = I1(i,j,:) - min(min(I1(i,j,:))) + ini_offset;
            
        end
            
        
    end
end

hist = calc_histog(I1);

Dr = sum(hist(1,1:15))*2 + sum(hist(1,15:50));
Bi = sum(hist(1,50:205)) + sum(hist(1,205:255))*2;

Iintr_en = zeros(w,h,d);
for i=1 : 1 : w
    for j=1 : 1 : h
        if(Bi > 2*Dr)
            Iintr_en(i,j,:) =(double(min(min(I1(i,j,:))))./double(max(max(MSF(i,j,:))))).*MSF(i,j,:);
            
        end
        if(Dr > 2*Bi)

            Iintr_en(i,j,:) =(double(max(max(I1(i,j,:))))./double(max(max(MSF(i,j,:))))).*MSF(i,j,:);
            
        end
    end
end

R=Iintr_en(:,:,1) ;
G=Iintr_en(:,:,2) ;
B=Iintr_en(:,:,3) ;
Lu = 0.299 * R + 0.587 * G + 0.114 * B;

GEO1 = zeros(w,h,d);
for i=1 : 1 : w
    for j=1 : 1 : h
       
          GEO1(i,j,:) = Iintr_en(i,j,:) .* (1 + exp(-14 .* (Lu(i,j) ./ 255).^2.2)) .* 1.25;
    end
end

figure;imshow(uint8(I1));title("input img");
%figure;plot(hist); xlabel("pixel value"); ylabel("count");title("histogram(input)");
figure;imshow(uint8(MSF));title("Proposed MSF");
figure;imshow(uint8(Iintr_en));title("Intermediate Enhanced");
%figure;imshow(uint8(GEO1));title("GEO on intermediate enhanced image");
%figure;imshow(uint8(GEO2));title("GEO on input image");
FLIME(uint8(Iintr_en));
% figure;imshow(uint8(HDR4));title("LIME on input image");




function [histog] = calc_histog(I1)
    [h,w,d] = size(I1);
    histog = zeros(1,256);
    for i = 1 : 1 : h
        for j = 1 : 1 : w

          histog(I1(i,j,:) + 1) = histog(I1(i,j,:) + 1) + 1;
        end
    end
end
    
function FLIME(filename)
clc;addpath(genpath('./'));

L = imresize(im2double(filename),1);

para.lambda = .15; % Trade-off coefficient
para.sigma = 2; % Sigma for Strategy III
para.gamma = 0.7; %  Gamma Transformation on Illumination Map
para.solver = 1; % 1: Sped-up Solver; 2: Exact Solver
para.strategy = 3;% 1: Strategy I; 2: II; 3: III

[I, T_ini,T_ref] = LIME(L,para);

figure;imshow(I);title('LIME on Intermediate Image');

end