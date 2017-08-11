function roundness = ecc2round(eccentricity)

ecc = eccentricity;
roundness = sqrt(1-ecc^2)/(1-sqrt(1-ecc^2));
end