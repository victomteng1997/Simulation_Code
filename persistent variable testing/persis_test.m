function [ result ] = persis_test( x )
%This is a simple testing for persistent variables
%In this way the optimization problem can be simplyfied in the easiest way
global y z
result = x * (y+z);


end

