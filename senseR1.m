function output = senseR1 (input, smap, psi)

%   Function performs SENSE recon with R = 1 for a single slice
%
%   input: input image (Nx, Ny, numcoil)
%   smap: sensitivity map (Nx, Ny, numcoil)
%   psi: (numcoil, numcoil)
%  
%   output: (Nx, Ny)


%% SENSE RECONSTRUCTION FOR R=1

[Nx, Ny, Nc] = size(input);
output = zeros(Nx,Ny);

for x = 1:Nx
   for y = 1:Ny

      % Assemble S matrix (Nc X 1)
      %S = zeros(Nc,1);
      S = squeeze(smap(x,y,:));

      % Assemble A matrix (Nc X 1)
      %alias = zeros(Nc,1);
      alias = squeeze(input(x,y,:));

      %output(x,y) = pinv(S'*inv(psi)*S)*S'*inv(psi) * alias; % where did this come from?
    
      output(x,y) = pinv(S'/psi*S)*S'/psi * alias; % where did this come from?
      % with psi=I, output(x,y) = pinv(S'*S)*S' * alias   

      % (1) pinv(S'*S)=1 always 
      % output = S'*alias 
      %        = [c1*/C, ...., cn*/C] [b1, ...., bn]'  where C = sqrt(abs(c1)^2 + abs(c2)^2 + ... )
      %        = (c1*xb1 + c2*xb2 + ... + cn*xbn)/C
      % this is always real because cn and bn have the same phase (almost, but not always)

      % (2) SENSE R1 = SOS if S(coil map) was acquired from alias(acquired data), that is c1=b1, c2=b2, ... cn=bn


%if(x == 71 && y == 36)
%   [y x]
%   S'*S
%end

   end
end



output = (output);

return


