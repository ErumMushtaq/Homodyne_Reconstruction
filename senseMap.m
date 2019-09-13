function [cmaps] = senseMap(b, sm);

% b: full resolution image (opxres, opyres, numcoil)
% sm: # of pixels of binomial smoothing, 0 = no smoothing)
% cmaps: sensitivity map (opxres, opyres, numcoil)

if (exist('sm')~=1) sm = 0; end

% low-pass filtering (smoothing) onto coil map and and images from all channels 
if (sm > 0)

  % Generate filter
  sfilt = [1];
  for index=1:sm  sfilt=filter2(sfilt,ones(2),'full'); end
%   imagesc(sfilt);
  %sfilt = ones(20);

%  % Smooth denominator of coil map
%  rsos = filter2(sfilt,rsos,'same');

  % Smooth numerator of coil map
  for index=1:size(b,3)
    b(:,:,index) = filter2(sfilt,b(:,:,index),'same');
  end

end

rsos = sqrt( sum( abs(b).^2,3 ) );

for index = 1:size(b,3)
  cmaps(:,:,index) = b(:,:,index) ./ rsos;
end


%if (sm == 1) 
%  [sm_rsos mask] = baselineFit(rsos);
%  for index = 1:size(b,3)
%	 sm_b(:,:,index) = baselineFit(real(b(:,:,index)), mask) + ...
%	                 j*baselineFit(imag(b(:,:,index)), mask);
%	 cmaps(:,:,index) = sm_b(:,:,index) ./ sm_rsos;
%  end
%end

