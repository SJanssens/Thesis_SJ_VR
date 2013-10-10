
function [train_utterance_block,test_utterance_block,train_blocks,test_blocks]=create_incremental_training_blocks(conf, blocks, blockstep_array, n_experiment)
%input
%blocks: cellarray of vectors with utt numbers
%blockstep_array: a vector of increasing numbers giving the number of administered blocks before each testing, in order to create a learning curve  
%n_experinment: number of folds or exp or subexp for obtaining robust scores
%output
%listings of trainingblocks, test_blocks and their respective listing of their utterance numbers 

n_blocks=length(blocks);
[ A ] = Latin_square(n_blocks, conf );%A is a latin square matrix n_blocks X n_blocks

if nargin<3
    blockstep_array=1:(n_blocks-1);
end

if nargin<4
    n_experiment=n_blocks;
end

% only the first n_experiment(if exist) rows in A are used, otherwise all rows 
% only the increasing blocksteps specified in blockstep_array are used,
% otherwise all entries in A are used
for i=1:n_experiment
    for j=1:length(blockstep_array)
        train_blocks{i,j}=A(1:blockstep_array(j)); % if blockstep_array=[1 3 4 10], then 1, 3,4, 10 first entries in the A-rows are incorporated in the training sets
        test_blocks{i,j}=A(blockstep_array(j)+1:end);% remainder for test
        train_utterance_block{i,j}=blocks{train_blocks{i,j}};% identical, but now for the utterances
        test_utterance_block{i,j}=blocks{test_blocks{i,j}};
    end
end
        
    