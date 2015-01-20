view1 = imread('Data\view1.png');
view5 = imread('Data\view5.png');

view1 = rgb2gray(view1);
view5 = rgb2gray(view5);

height = size(view1,1);
width = size(view1,2);

% DP Matrix
DP = zeros(width,width,height);
DP(1,1,:) = 0;

% Iterate for all layers of DP matrix
y = 1;

% Pre allocate variables
occlusion = 100000;
a1 = 0;
a2 = 0;
a3 = 0;
dif = 0;
b1 = 0;
b2 = 0;
b3 = 0;
b4 = 0;
c1 = 0;
c2 = 0;
c3 = 0;
c4 = 0;
left_disparity = zeros(height,width);
right_disparity = zeros(height,width);
path = zeros(width,width,height);

while y ~= height
    % Calculate layers of DP Matrix
    
    % Cycle through all current scan line values
    % to populate a layer of DP
    for i = 1 : width
        for j = 1 :width

            % Data goes in
            a1 = double(view5(y,j));
            a2 = double(view1(y,i));
            
            % Difference
            dif = abs(a1 - a2);
            
            % Read from DP matrix and take lowest-cost
            % inferior neighbor
            b1 = 0;
            b2 = 0;
            b3 = 0;
                if i-1 > 1
                    b1 = DP(i-1,j,y);
                end
                if j-1 > 1
                    b2 = DP(i,j-1,y);
                end
                if i-1 > 1 && j-1 > 1
                    b3 = DP(i-1,j-1,y);
                end


            b4 = min([b1 b2 b3]);
            
            
            
            % Write to DP Matrix
            DP(i,j,y) = dif + b4;
            
        end
    end
    
    % Account for occlusion?
%     for i = 1 : width
%        DP(i,1,y) = 10000000; 
%     end
%     
%     for i = 1 : width
%        DP(1,i,y) = 10000000;
%     end
    
    % Find Path through current DP matrix layer
    i = width;
    j = width;
    path(width,width,y) = 1;
    while 1
           % Read from current DP matrix layer

           c1 = DP(i-1,j,y);
           
           
           c2 = DP(i,j-1,y);
           
           
           c3 = DP(i-1,j-1,y);
           
           % Minimum cost
           c4 = min([c1 c2 c3]);
           
           % Go to new position
           if c1 == c2 && c2 == c3 && c3 == c4
              j = j-1; % default
              i = i-1;
           elseif c4 == c3
              j = j-1;
              i = i-1;
%               right_disparity(y,i) = abs(i-j);
%               left_disparity(y,j) = abs(i-j);
           elseif c4 == c2
               j = j-1;
           elseif c4 == c1
               i = i-1;
           end
           
           % Write to path
          
           path(i,j,y) = 1;
          
           % Write to disparity maps


           
           
           if i == 1 || j == 1
               break;
           end
           
    end
    
    % backtrack
%     i = 1;
%     j = 1;
    while 1
       % starting at path(1,1,y).. trace downward through the path 
       
       % check right
       d1 = path(i,j+1,y);
       % check down
       d2 = path(i+1,j,y);
       % check down-right
       d3 = path(i+1,j+1,y);
       
       % where's the 1?
       if d1 == 1
           j = j+1;
       elseif d2 == 1
           i = i+1;
       elseif d3 == 1
           i = i+1;
           j = j+1;
           % Update maps
           right_disparity(y,i) = abs(i-j);
           left_disparity(y,j) = abs(i-j);
       end
       
       if i == width || j == width
           break;
       end
    end
    
    
    
   y = y+1; 
end

imshow(left_disparity,[0 70]);
figure;
imshow(right_disparity,[0 70]);