classdef node < handle
    properties
        x
        y
        id
        level
    end
    
    methods
        function obj = node(x,y,level)
            obj.x = x;
            obj.y = y;
            obj.level = level;
        end
        
    end
end


