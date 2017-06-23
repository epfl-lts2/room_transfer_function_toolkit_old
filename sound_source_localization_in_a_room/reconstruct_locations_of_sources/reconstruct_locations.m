function [reconstructed_indices, reconstruction_error] = ...
    reconstruct_locations(signal, K)
addpath('./reconstruct_locations_of_sources/sparse_methods')
data = load('../data/dictionary.mat');
dictionary = data.dictionary;
[x,~,~,residHist,~] = CoSaMP2(dictionary, signal, K,[],'');
reconstruction_error = residHist(end);
reconstructed_indices = find(x);