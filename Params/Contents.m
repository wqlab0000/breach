% PARAMS
%
% Files
%   CountRefine       - counts the number of points that would be generated by the same call to Refine
%   CreateSampling    - Create a parameter set structure for a system
%   DiscrimPropValues - Separates traj set S according to properties checked for S
%   FindParam         - Finds the indices of parameters given by their name for a given system or param set
%   GetParam          - get the values of parameters in a parameter set
%   HaltonRefine      - Sample quasi-uniformly a parameter set using Halton sequence
%   pRefine           - pick initial points for the Morris global sensitivity measure
%   Refine            - Generates grid points in a N-dimensional parameter set 
%   SConcat           - concat two parameter sets 
%   SetParam          - set the values of parameters in a parameter set
%   Psave             - save a parameter set in the default param set file of a system
%   SPurge            - Remove all fields related to a specific computation of trajectories  
%   SPurge_props      - Removes values of satisfaction functions in a parameter set
%   Sselect           - extract parameters from indices
%   SXf2X0            - creates a new parameter set from the end points of trajectories
%   VoronoiRefine     - Voronoi diagram based refinement (experimental)
