function [levels, paths, sons] = get_levels_paths_sons()


levels = [1,2,2,3,3,3,3];

paths = [1,2,4,8;
    1,2,4,9;
    1,2,5,10;
    1,2,5,11;
    1,3,6,12;
    1,3,6,13;
    1,3,7,14;
    1,3,7,15];

%node left right
sons = [1,2,3;
    2,4,5;
    3,6,7;
    4,8,9;
    5,10,11;
    6,12,13;
    7,14,15];

end
