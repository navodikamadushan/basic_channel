% Detector

% Copyright (c) 2021 Navodika Karunasingha <navodikaefac@gmail.com>
function [m] = detect(z,r_0)
r_0=0; %threshold level
m=[];
    for ii=1:length(z)
        if z(ii) >= r_0
            m(ii)=1;
        else
            m(ii)=0;
        end
    end
end