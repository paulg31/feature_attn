function eccentricity = round2ecc(roundness)

eccentricity = sqrt(-((roundness/(1+roundness))^2)+1);
end