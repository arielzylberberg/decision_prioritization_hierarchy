function B = bezier(p)
% p must be a 4 x 2 matrix
%order: first anchor point, first control point, second control point, second
%anchor point;

[nx,ny] = size(p);
if ~(nx==4 && ny==2)
    error('wrong size');
end

t = linspace(0,1,500);

m = [(1-t).^3; 3*(1-t).^2.*t; 3*(1-t).*t.^2; t.^3]';
B = m*p;

