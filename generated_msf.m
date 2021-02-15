clear all;close all;clc;

I1 = imread("fish-input.jpg");

[w,h,d] = size(I1);

for i = 1 : 1 : w
    for j = 1 : 1 : h
        sum(i,j) = min(min(I1(i,j,:)));
        
    end
end
 offset = mean2(sum);
 ini_offset = offset;
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
% I2(i,j,:) = I1(i,j,:) - min(min(I1(i,j,:))) + offset;

                                            
figure;imshow(I1);title("Input");
figure;imshow(uint8(MSF));title("MSF");

I3 = imread("conventional_msf_skull.png");
I4 = imread("proposed_msf_skull.png");

figure;imshow(uint8(I3-I4));title("I3-I4");
