Everything should work by running the runfile. 
If for some reason the runfile won't work, just run each part separately. 
The only weird thing is part 1 is split into Block_Matching.m and consistency.m
both of which just need to be run one after the other.

Some potentially useful things:
BlockMatching disparity maps are stored in variables "disp1" and "disp5"
Consistency-checked maps are in "disp1c" and "disp5c"
Dynamic Programming maps are in "left_disparity" and "right_disparity"
View Interpolation is in "i3"