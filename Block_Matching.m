% Block Matching
%%
% Preprocessing
% --------------
% Read in image data
view1 = imread('Data/view1.png');
view3 = imread('Data/view3.png');
view5 = imread('Data/view5.png');

% Convert to double
view1 = im2double(view1);
view3 = im2double(view3);
view5 = im2double(view5);

% Convert from RGB to grayscale
view1 = rgb2gray(view1);
view3 = rgb2gray(view3);

view5 = rgb2gray(view5);

% Pad images;
view1 = padarray(view1,[50 50]);
view3 = padarray(view3,[50 50]);
view5 = padarray(view5,[50 50]);

% Calc height, width, etc
height = size(view1,1);
width = size(view1,2);

% Create empty disparity map to match view1's dimensions
disp1 = zeros(height,width);
disp5 = zeros(height,width);

% Window size (2n+1 x 2n+1)
winsize = 1;

% Window Allocation
win1 = zeros(winsize+1,winsize+1);
win5 = zeros(winsize+1,winsize+1);

% Default SSD values
check_SSD = 0;
%%
% Generate Map 1
for i = 51:height-50
   for j = 51:width-50
       % reset lowest SSD
       lowest_SSD = 999999999999;
       
       % Calculate window bounds of win1 in view1
       colLow = j - winsize;
       colHigh = j + winsize;
       rowLow = i - winsize;
       rowHigh = i + winsize;
       
       % Populate win1
       win1 = view1( (rowLow:rowHigh) , (colLow:colHigh) );
       
       % Cycle through the current row starting at j in view1
       for k = 51: j
           % Calculate window bounds of win5 in view5
           colLow = k - winsize;
           colHigh = k + winsize;
           rowLow = i - winsize;
           rowHigh = i + winsize;
           
           % Populate win5
           win5 = view5( (rowLow:rowHigh) , (colLow:colHigh) );
           
           % SSD it with win1
           check_SSD = sum(sum((win1-win5).^2));
           
           if check_SSD < lowest_SSD
              lowest_SSD = check_SSD;
              % Calculate and record disparity
              disp1(i,j) = j - k;
           end
       end
   end
end

% Remove padding
disp1 = disp1(51:height-50,51:width-50);

%%
% Generate Map 5
for i = 51:height-50
   for j = 51:width-50
       % reset lowest SSD
       lowest_SSD = 999999999999;
       
       % Caclulate bounds of win5
       colLow = j - winsize;
       colHigh = j + winsize;
       rowLow = i - winsize; 
       rowHigh = i + winsize;
           
       % Populate win5
       win5 = view5( (rowLow:rowHigh) , (colLow:colHigh) );
       
       % Cycle through the current row starting at j in view1
       for k = j : width-50
           
           % Calculate bounds of win1
           colLow = k - winsize;
           colHigh = k + winsize;
           rowLow = i - winsize; 
           rowHigh = i + winsize;
           
           % Populate win1
           win1 = view1( (rowLow:rowHigh) , (colLow:colHigh) );
           
           % SSD it with win5
           check_SSD = sum(sum((win1-win5).^2));
           
           if check_SSD < lowest_SSD
              lowest_SSD = check_SSD;
              % Calculate and record disparity
              disp5(i,j) = k - j;
           end
       end
   end
end
% Remove padding
disp5 = disp5(51:height-50,51:width-50);

imshow(disp1,[0 70]);
figure;
imshow(disp5,[0 70]);
figure;

%imshow(Disparity,[]), axis image, colormap('jet'), colorbar;
%caxis([0 disparityRange]);
%imwrite('DisparityBasic.png', Disparity);