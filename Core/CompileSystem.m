function CompileSystem(Sys)
%    
%   Compile the C function defining the dynamics, enabling simulations. 
%       
%   Syntax: CompileSystem(Sys)
%   
%   Prerequisite: the presence of properly defined files
%                        - dynamics.cpp 
%                        - dynamics.h 
%                        - dynamics.mk                                  
%                 in the current directory.
%
%   Inputs: 
%   
%    -  Sys      system structure, usually created by CreateSystem script 
%  
   
  
  h = waitbar(0,'Compiling System, please wait...');

  
  % find out host architecture
    
  ext = mexext;
  switch( ext )
   case {'mexw64', 'mexw32'}
    obj_ext = '.obj ';
   otherwise
    obj_ext = '.o ';
  end
      
  dr = which('Breach');
  breach_dir = dr(1:end-9);
  
  breach_src_dir = [breach_dir filesep 'Core' filesep 'src']; 
  qmitl_src_dir = [breach_dir filesep '@QMITL_Formula' filesep 'private' filesep 'src'];
  cvodes_src_dir = [breach_dir filesep 'Toolboxes' filesep 'sundials' filesep 'src'];
  
  sundials_dir = [breach_dir filesep 'Toolboxes' filesep 'sundials'];
  sundials_inc_dir = [sundials_dir filesep 'include'];
  sundials_src_dir = [sundials_dir filesep 'src' filesep 'sundials'];
  sundials_cvodes_src_dir = [sundials_dir filesep 'src' filesep 'cvodes'];
  sundials_nvm_src_dir = [sundials_dir filesep 'sundialsTB' filesep 'nvector' filesep 'src'];
  cvodesTB_src_dir =  [breach_dir filesep 'Core' filesep 'cvodesTB++' filesep 'src'];
    
  % Blitz 
  
  blitz_inc_dir= [breach_dir filesep 'Toolboxes' filesep 'blitz' filesep 'include'];  
  blitz_lib = [ breach_dir filesep 'Toolboxes' filesep 'blitz' filesep 'lib' filesep 'libblitz' obj_ext];    
  
 % out directories
  
  obj_out_dir = [breach_src_dir  filesep 'obj'];
  cv_obj_out_dir = [breach_src_dir  filesep 'cv_obj'];
  sys_src_dir = Sys.Dir;
  
  % flags 
  
  switch( ext )
   case {'mexw64', 'mexw32'}
    compile_flags = [' -DDIMX=' num2str(Sys.DimX) ' '];    
   case {'mexglx'}
    compile_flags = [' -DDIMX=' num2str(Sys.DimX) ' -D_DEBUG=0' ' -cxx '];
   otherwise
    compile_flags = [' -DDIMX=' num2str(Sys.DimX) ' '];
  end
    
  inc_flags = [' -I' sys_src_dir ...
               ' -I' breach_src_dir ...
               ' -I' sundials_inc_dir ...
               ' -I' sundials_cvodes_src_dir ...
               ' -I' cvodesTB_src_dir ...
               ' -I' sundials_nvm_src_dir ...
               ' -I' blitz_inc_dir ...
               ' -I' blitz_inc_dir filesep 'blitz' ...
              ];
  
  % source files

  cvodesTB_src_files = [cvodesTB_src_dir filesep 'cvmFun.cpp ' ...
                    cvodesTB_src_dir filesep 'cvmWrap.cpp ' ...
                    cvodesTB_src_dir filesep 'cvmOpts.cpp ' ...
                  ];     
  
  cv_obj_files = [  
      cv_obj_out_dir filesep 'cvmFun' obj_ext  ...
      cv_obj_out_dir filesep 'cvodea' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_dense' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_spbcgs' obj_ext  ...
      cv_obj_out_dir filesep 'nvector_serial' obj_ext  ...
      cv_obj_out_dir filesep 'sundials_dense' obj_ext  ...
      cv_obj_out_dir filesep 'sundials_smalldense' obj_ext  ...
      cv_obj_out_dir filesep 'cvmOpts' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_band' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_diag' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_spgmr' obj_ext  ...
      cv_obj_out_dir filesep 'nvm_ops' obj_ext  ...
      cv_obj_out_dir filesep 'sundials_iterative' obj_ext   ...
      cv_obj_out_dir filesep 'sundials_spbcgs' obj_ext  ...
      cv_obj_out_dir filesep 'cvmWrap' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_bandpre' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_io' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_spils' obj_ext  ...
      cv_obj_out_dir filesep 'nvm_serial' obj_ext  ...
      cv_obj_out_dir filesep 'sundials_math' obj_ext  ...
      cv_obj_out_dir filesep 'sundials_spgmr' obj_ext  ...
      cv_obj_out_dir filesep 'cvodea_io' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_bbdpre' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes' obj_ext  ...
      cv_obj_out_dir filesep 'cvodes_sptfqmr' obj_ext  ...
      cv_obj_out_dir filesep 'sundials_band' obj_ext  ...
      cv_obj_out_dir filesep 'sundials_nvector' obj_ext  ...
      cv_obj_out_dir filesep 'sundials_sptfqmr' obj_ext ];      
  
  
  src_files = [sys_src_dir filesep 'dynamics.cpp ' ...
               breach_src_dir filesep 'mextools.cpp ' ...
               breach_src_dir filesep 'traj.cpp ' ...
               breach_src_dir filesep 'param_set.cpp ' ...
               breach_src_dir filesep 'breach.cpp ' ...
              ];     
  
  obj_files = [obj_out_dir filesep 'dynamics' obj_ext  ...
               obj_out_dir filesep 'mextools' obj_ext  ...
               obj_out_dir filesep 'traj' obj_ext  ...
               obj_out_dir filesep 'param_set' obj_ext  ...
               obj_out_dir filesep 'breach' obj_ext  ...
              ];       
       
  % compile commands
  
  compile_cvodes_cmd= ['mex -c -outdir ' cv_obj_out_dir ' ' compile_flags ' ' inc_flags ' ' cvodesTB_src_files ];
  compile_obj_cmd = ['mex -c -outdir ' obj_out_dir ' ' compile_flags ' ' inc_flags ' ' src_files ];  
  compile_cvm_cmd= ['mex -output cvm ' compile_flags obj_files cv_obj_files blitz_lib ];
    
  % execute commands

  waitbar(1 / 4); 
  cd(sys_src_dir);
  fprintf([regexprep(compile_cvodes_cmd,'\','\\\\') '\n' ]);
  eval(compile_cvodes_cmd);
  waitbar(2 / 4); 
  fprintf([regexprep(compile_obj_cmd,'\','\\\\') '\n']);
  eval(compile_obj_cmd);
  waitbar(3 / 4); 
  fprintf([regexprep(compile_cvm_cmd,'\','\\\\') '\n']);
  eval(compile_cvm_cmd);
  waitbar(4 / 4); 
  close(h);