function [word_sharings_matrix, identity_words] = load_word_sharings_matrix(masterframes)
    % word_sharings_matrix is a square matrix and multiplied (leftside) to the
    % columnvector labelvec or to labelmat
    % This function builds on the assumption that the rows in the labelmatrix
    % have the same order than the summation of frames, slots and values in the
    % masterframe function.
    % An extra row is assumed to be inserted for an empty frame
    
    word_sharings_matrix = eye(masterframes.numvalues);
    
    [~,unique_rowindices]=unique(word_sharings_matrix','rows');% is used to create blocks
    identity_words=word_sharings_matrix(:,sort(unique_rowindices))';
    identity_words=bsxfun(@rdivide, identity_words, sum(identity_words, 2));
    %identity_words is able to turn the labelmatrix into the keywords, i.e.
    %the original labelmatrix of Joris driessen door
    %identity_words*word_sharings_matrix*labelframeslotvalue_mat is de
    %oorspronkelijke labelmat
end