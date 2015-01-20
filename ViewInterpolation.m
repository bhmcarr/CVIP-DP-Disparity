% parameters
interp = 0.5;   % interpolation factor of 0.5 should give a virtual view exactly at the center of line connecting both the cameras. can vary from 0 (left view) to 1 (right view)

% read in images and disparity maps
i1 = imread('Data/view1.png');           % left view
i2 = imread('Data/view5.png');           % right view
i_test = imread('Data/view3.png');       % middle view (for calculating mse)
d1 = double(imread('Data/disp1.png'));   % left disparity map, 0-255
d2 = double(imread('Data/disp5.png'));   % right disparity map, 0-255

% tag bad depth values with NaNs
d1(d1==0) = NaN;
d2(d2==0) = NaN;

% Pad images
i1 = padarray(i1,[100 100]);
i2 = padarray(i2,[100 100]);
d1 = padarray(d1,[100 100]);
d2 = padarray(d2,[100 100]);

% make a new image i3
height = size(i1,1);
width = size(i1,2);
i3 = uint8(zeros(height,width,3));
i4 = uint8(zeros(height,width,3));

%%
% shift view1
for i = 101 : height-100
   for j = 101 : width-100
      % Go to current pixel in disparity map
      if isnan(d1(i,j)) == false
          disparity_value = d1(i,j,:);
          disparity_value = disparity_value * interp;
          disparity_value = round(disparity_value);
      
          % Take current pixel from i1 and put it in the right spot in i3
          i3(i,j-disparity_value,:) = i1(i,j,:);
      end
       
   end
end

%%
% shift view5
for i = 101 : height-100
   for j = 101 : width-100
       if isnan(d2(i,j)) == false
          disparity_value = d2(i,j,:);
          disparity_value = disparity_value * interp;
          disparity_value = round(disparity_value);
          
          i4(i,j+disparity_value,:) = i2(i,j,:);
       end
   end
end

%%
% Fill in holes in i1

for i = 101 : height-100
   for j = 101 : width-100
       if i3(i,j,:) == 0
          i3(i,j,:) = i4(i,j,:);
       end
   end
end

%%
% Remove Padding

i3 = i3(101:height-100,101:width-100,:);

%%
% Calculate MSE
height = size(i3,1);
width = size(i3,2);

coef = height*width;
coef = 1 / coef;
mse_i3 = nansum(nansum(nansum((i3 - i_test).^2)));
mse_i3 = mse_i3 * coef;

imshow(i3);











