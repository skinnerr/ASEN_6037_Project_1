function [ u,v,w ] = read_dns_data( simulation_case )
%% Reads data from the DNS simulation.
%   simulation_case: either 'HIT' or 'HST'

% Change folder to where our data is stored and establish filenames.
origin_dir = cd('../data/');
if (strcmp(simulation_case,'HIT')) %homogeneous isotropic turbulence
    datu='HIT_u.bin';  %u velocity data
    datv='HIT_v.bin';  %v velocity data
    datw='HIT_w.bin';  %w velocity data
elseif (strcmp(simulation_case,'HST')) %homogeneous shear turbulence
    datu='HST_u.bin';  %u velocity data
    datv='HST_v.bin';  %v velocity data
    datw='HST_w.bin';  %w velocity data
end
    
%Case parameters
nx=[256,129,256];  %grid dimensions
lx=[2*pi,pi,2*pi]; %domain size
dx=lx./nx;         %grid cell size (resolution)

%Read in u velocity field
fid=fopen(datu);
tmp0=fread(fid,nx(1)*nx(2)*nx(3)+2,'single','l');
tmp(1:nx(1)*nx(2)*nx(3))=tmp0(2:nx(1)*nx(2)*nx(3)+1);
clear tmp0;
fclose(fid); 
clear u;
u=reshape(tmp,nx(1),nx(2),nx(3));
clear tmp;

%Read in v velocity field
fid=fopen(datv);
tmp0=fread(fid,nx(1)*nx(2)*nx(3)+2,'single','l');
tmp(1:nx(1)*nx(2)*nx(3))=tmp0(2:nx(1)*nx(2)*nx(3)+1);
clear tmp0;
fclose(fid); 
clear v;
v=reshape(tmp,nx(1),nx(2),nx(3));
clear tmp;

%Read in w velocity field
fid=fopen(datw);
tmp0=fread(fid,nx(1)*nx(2)*nx(3)+2,'single','l');
tmp(1:nx(1)*nx(2)*nx(3))=tmp0(2:nx(1)*nx(2)*nx(3)+1);
clear tmp0;
fclose(fid); 
clear w;
w=reshape(tmp,nx(1),nx(2),nx(3));
clear tmp;

cd(origin_dir);

end