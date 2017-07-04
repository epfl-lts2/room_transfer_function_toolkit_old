function [reconstructed_indices, reconstruction_error] = ...
    reconstruct_locations(signal, K)
data = load('../data/dictionary.mat');
dictionary = data.dictionary;
[x,~,~,residHist,~] = CoSaMP(dictionary, signal, K,[],'');
reconstruction_error = residHist(end);
reconstructed_indices = find(x);