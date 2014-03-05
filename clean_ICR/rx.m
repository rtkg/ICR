function Rx = rx(A)
%
% ------------------------------------------------------
% | Basic Multibody Simulator Derived (Matlab toolbox) |
% ------------------------------------------------------
% | Rotations |
% -------------
%
% rx
%
% Returns a rotation matrix (X axis)
%
% Syntax:
% -------
% Rx = rx(A)
%
% Input:
% ------
% A  [1x1]   - angule [rad] 
%
% Output:
% -------
% Rx  [3x3]  - rotation matrix (X axis)
%

% Algorithm:
% ----------
% see http://en.wikipedia.org/wiki/Rotation_matrix

%
% Version 1.0 [2009/07]
%
% This toolbox is developed by Dimitar Dimitrov for educational purpose.
% Contact me at: dimitar.dimitrov@oru.se
% ----------------------------------------------------

Rx = [1        0         0 ; 
      0   cos(A)   -sin(A) ;
      0   sin(A)    cos(A)];

%%%EOF