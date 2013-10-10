function print_title(output_fileID, title_string, level)

% ------------------------------------------------------------------
% Prints a title (title_string). 
% Depending on the level (1, 2 or 3), a different format is chosen.
% ------------------------------------------------------------------

switch level
    case 1
        title_string = upper(title_string);
        title_string = ['+   ' title_string '   +']; 
        fprintf(output_fileID, '\n');
        for i = 1:length(title_string)
            fprintf(output_fileID, '%s', '+');
        end
        fprintf(output_fileID, '\n');
        fprintf(output_fileID, '%s', '+');
        for i = 1:(length(title_string)-2)
            fprintf(output_fileID, '%s', ' ');
        end
        fprintf(output_fileID, '%s', '+');
        fprintf(output_fileID, '\n');
        fprintf(output_fileID, '%s\n', title_string);
        fprintf(output_fileID, '%s', '+');
        for i = 1:(length(title_string)-2)
            fprintf(output_fileID, '%s', ' ');
        end
        fprintf(output_fileID, '%s', '+');
        fprintf(output_fileID, '\n');
        for i = 1:length(title_string)
            fprintf(output_fileID, '%s', '+');
        end
        fprintf(output_fileID, '\n');
        fprintf(output_fileID, '\n');
    case 2
        title_string = upper(title_string);
        title_string = ['--- ' title_string ' ---'];
        fprintf(output_fileID, '\n');
        for i = 1:length(title_string)
            fprintf(output_fileID, '%s', '-');
        end
        fprintf(output_fileID, '\n');
        fprintf(output_fileID, '%s\n', title_string);
        for i = 1:length(title_string)
            fprintf(output_fileID, '%s', '-');
        end
        fprintf(output_fileID, '\n');
        fprintf(output_fileID, '\n');
        fprintf(output_fileID, '\n');
    case 3
        title_string = upper(title_string);
        title_string = ['--- ' title_string ' ---'];
        fprintf(output_fileID, '\n');
        fprintf(output_fileID, '%s\n', title_string);
        fprintf(output_fileID, '\n');
        fprintf(output_fileID, '\n');
end
