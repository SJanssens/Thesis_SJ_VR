function [fnames, nb_files] = getfilenames(conf)    
    
    filenamelist=conf.fileconf.filelist;% This should be the filelist
    
    fileID=fopen(filenamelist);
    fnames=textscan(fileID,'%s\n'); % get filenames from the file
    fclose(fileID);

    fnames = fnames{1};
    nb_files=size(fnames,1); % get number of files (= number of rows of column vector 'fnames')
