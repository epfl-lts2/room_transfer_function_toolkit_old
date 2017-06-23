function [] = dictionary_benchmarking()
data = load('../data/dictionary.mat');
dictionary = data.dictionary;
[mu, angle] = get_coherence_of_dictionary(dictionary);
disp(['Coherence parameter of the dictionary: ', num2str(mu), '.'])
disp(['It corresponds to an angle of: ', num2str(angle), ' degrees.'])