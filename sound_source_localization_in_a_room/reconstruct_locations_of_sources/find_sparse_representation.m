function [S, index_set] = find_sparse_representation(X, D, K, method)
% Input:
% X - samples matrix, one signal each column
% D - dictionary, each column with unit norm
% K - spasity level
% Output:
% S - sparse coding matrix
% index_set - set of indices of used atoms in the dictionary
switch(method)
    case SparseMethods.SOMP
        [S, index_set] = SOMP(X, D, K);
    case SparseMethods.SCoSaMP
        alpha = 4;
        [S, index_set] = SCoSaMP(X, D, K, alpha);
    case SparseMethods.FISTA
        [S, index_set] = FISTA(X, D, K);
    otherwise
        msgID = 'MYFUN:incorrectSparseRepresenatationMethod';
        msg = 'Wrong name of the sparse representation method';
        wrongMethodException = MException(msgID,msg);
        throw(wrongMethodException);
end
end