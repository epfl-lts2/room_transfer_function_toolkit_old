function [S, index_set] = FISTA(X, D, K)
% Input:
% X - samples matrix, one signal each column
% D - dictionary, each column with unit norm
% K - spasity level
% Output:
% S - sparse coding matrix
% index_set - set of indices of used atoms in the dictionary

y = reshape(X, size(X,1)*size(X,2), 1);
A = D;
x = zeros(size(A,2), 1); 
% Defining proximal operators
verbose = 1;
tau = .1;
% setting the function f2 
f2.grad = @(x) 2*A'*(A*x-y);
f2.eval = @(x) norm(A*x-y)^2;
f2.beta = 2 * norm(A)^2;
% setting the function f1
param_l1.verbose = verbose -1;
param_l1.tight = 1;
f1.prox=@(x, T) prox_l1(x, T*tau, param_l1);
f1.eval=@(x) tau*norm(x,1);   
% setting different parameters for the simulation
param_solver.verbose = verbose; % display parameter
param_solver.maxit = 300;       % maximum iteration
param_solver.tol = 1e-4;        % tolerance to stop iterating
param_solver.method = 'FISTA';  % desired method for solving the problem

% solving the problem
coefficients = solvep(zeros(size(x)), {f1, f2}, param_solver);

% nnz function retuns the number of nonzero elements in a function
if (nnz(coefficients) == 0)
    index_set = 0;
    S = 0;
else
    % return the indices of the top ones
    [~, sorted_energy_indices] = sort(coefficients.^2, 'descend');
    index_set = sorted_energy_indices(1:min(K, nnz(coefficients)));
    S = D(:,index_set)*coefficients(index_set);
end
end