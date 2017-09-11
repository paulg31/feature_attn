function targetRoundness = computeTargetRoundness(rel_vec,error_vec,targetSDerror,beta_b)
%COMPUTETARGETROUNDNESS Compute roundness for given target SD error.
%The error must be expressed in degrees (-90 to 90 deg).

if nargin < 5; beta_b = []; end

nsigma = 51;
nlambda = 41;
sigma_a(:,1,1) = exp(linspace(log(targetSDerror/2), log(targetSDerror), nsigma));
sigma_diff(1,:,1) = exp(linspace(log(1), log(targetSDerror), nsigma));
lambda(1,1,:) = linspace(1e-6,0.1,nlambda);

roundness_a = min(rel_vec);
roundness_b = max(rel_vec);

loglike = zeros(nsigma,nsigma,nlambda);

% Tight prior over lapse rate
beta_a = 1;
if isempty(beta_b); beta_b = 99; end
loglike = bsxfun(@plus, loglike, (beta_a-1)*log(lambda) + (beta_b-1)*log(1-lambda) ...
    - gammaln(beta_a) - gammaln(beta_b) + gammaln(beta_a + beta_b));

% Compute log likelihood summed over trials
for iTrial = 1:numel(rel_vec)
    sigma_mat = bsxfun(@plus, sigma_a, (rel_vec(iTrial) - roundness_a)/(roundness_b - roundness_a)*sigma_diff);
    trialLike = bsxfun(@plus, bsxfun(@times, 1 - lambda, exp(-0.5*(error_vec(iTrial)./sigma_mat).^2)./sigma_mat/sqrt(2*pi)), ...
        lambda/180);
    loglike = loglike + log(trialLike);
end

% Compute likelihood
loglike = loglike - max(loglike(:));
like = exp(loglike);

% Marginalize over lapse rate and normalize
like = sum(like,3);
like = like / sum(like(:));

% Compute target roundness for all pairs of sigmas
roundness_mat = max(roundness_a + bsxfun(@times, (roundness_b - roundness_a)./sigma_diff, targetSDerror - sigma_a),0);

% Compute expected target roundness
targetRoundness = sum(like(:) .* roundness_mat(:));

end