function [S, index_set] = SCoSaMP(X, D, K, alpha)
% Input:
% X - samples matrix, one signal each column
% D - dictionary, each column with unit norm
% K - spasity level
% alpha - tuning parameter
% Output:
% S - sparse coding matrix
% index_set - set of indices of used atoms in the dictionary 

% Algorithm as described in "CoSaMP: Iterative signal recovery from 
% incomplete and inaccurate samples" by Deanna Needell and Joel Tropp.
% This implementation was written by David Mary, 
% but modified 20110707 by Bob L. Sturm to make it much clearer,
% and corrected multiple times again and again.
% To begin with, see: http://media.aau.dk/null_space_pursuits/2011/07/ ...
% algorithm-power-hour-compressive-sampling-matching-pursuit-cosamp.html

% This implementation needed to be adjusted for the simultanoeus use case
maxiterations = 100;
tol = 1e-10;
X = reshape(X, size(X,1)*size(X,2), 1);
R = X;
t = 1; 
numericalprecision = 1e-12;
index_set = [];
while (t <= maxiterations) && (norm(R)/norm(X) > tol)
  y = sum(abs(D'*R),2); % here is the only thing that was adjusted
  [vals, ~] = sort(y,'descend');
  new_index_set = find(y >= vals(alpha*K) & y > numericalprecision);
  index_set = union(new_index_set, index_set);
  exp_coeff = pinv(D(:, index_set))*X;
  y = sum(abs(exp_coeff),2);
  [vals, ~] = sort(y,'descend');
  index_set_reduced = (y >= vals(K) & y > numericalprecision);
  index_set = index_set(index_set_reduced);
  dictionary_subset = zeros(size(D));
  dictionary_subset(:,index_set) = D(:,index_set);
  R = X - dictionary_subset*(pinv(dictionary_subset)*X);
  t = t+1;
end
S = dictionary_subset*(pinv(dictionary_subset)*X);
end