% disp1 = im2double(disp1);
% disp5 = im2double(disp5);


%Consistency Checking
disp5c = disp5;
disp1c = disp1;
height = size(disp5c,1);
width = size(disp5c,2);
 
% Load up and scale the ground truth data
truth5 = double(imread('Data/disp5.png'));
truth1 = double(imread('Data/disp1.png'));
%%

% Start checking consistency for disp5

for i = 1 : height
   for j = 1 : width
      % Take a disparity value from disp5 (right image)
      right_disparity = disp5c(i,j);
      
      % Go to the same pixel in left image but add disparity from right
      left_disparity = disp1c(i,j+right_disparity);
      
      % Check if left_disparity is the same
      if left_disparity ~= right_disparity
         % Right pixel disparity assignment is spurious
         % Get rid of it
         disp5c(i,j) = NaN; 
      end
   end
end

%%
%Calculate MSE for disp5
coef = height*width;
coef = 1 / coef;
mse5 = nansum(nansum((double(disp5c) - truth5).^2));
mse5 = mse5 * coef;

%%
% Replace values with ground truth

% for i = 1 : height
%    for j = 1 : width 
%         if isnan(disp5c(i,j))
%            disp5c(i,j) = truth5(i,j); 
%         end
%    end
% end

%%
%Start consistency checking for disp1

for i = 1 : height
   for j = 1 : width
      % Take a disparity value from disp5 (right image)
      left_disparity = disp1c(i,j);
      
      % Go to the same pixel in left image but add disparity from right
      right_disparity = disp5c(i,j-left_disparity);
      
      % Check if left_disparity is the same
      if right_disparity ~= left_disparity
         % Right pixel disparity assignment is spurious
         % Get rid of it
         disp1c(i,j) = NaN; 
      end
   end
end

%%
%Calculate MSE for disp1

coef = height*width;
coef = 1 / coef;
mse1 = nansum(nansum((double(disp1c) - truth1).^2));
mse1 = mse1 * coef;

%%
% Export Data
% 
% disp1_export = disp1 ./70;
% disp5_export = disp5 ./70;
% 
% imwrite(disp1_export,'Evaluation/Books/Collection/win3/disp1_3.png');
% imwrite(disp5_export,'Evaluation/Books/Collection/win3/disp5_3.png');
% 
imshow(disp1c);
figure;
imshow(disp5c);
figure;
disp(mse1);
disp(mse5);



