function [mu, angle] = get_coherence_of_dictionary(dictionary)

gram_matrix = dictionary'*dictionary;
%gram_matrix = gram_matrix/size(dictionary, 1);
gram_matrix = abs(gram_matrix);
gram_matrix(logical(eye(size(gram_matrix)))) = 0;
[val, ~] = max(max(gram_matrix));
mu = val;
angle = rad2deg(acos(val));