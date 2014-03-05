function Ry = ry(A)
%
% ------------------------------------------------------
% | Basic Multibody Simulator Derived (Matlab toolbox) |
% ------------------------------------------------------
% | Rotations |
% -------------
%
% ry
%
% Returns a rotation matrix (Y axis)
%
% Syntax:
% -------
% Ry = ry(A)
%
% Input:
% ------
% A  [1x1]   - angule [rad] 
%
% Output:
% -------
% Ry  [3x3]  - rotation matrix (Y axis)
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

Ry = [ cos(A)    0    sin(A) ; 
            0    1         0 ;
      -sin(A)    0    cos(A)];

%%%EOF