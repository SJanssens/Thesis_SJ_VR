% convert a vector of numbers to a cell with numbers
% a replacement for the one-liner:
% cellstr(num2str((1:13)'))'
% since that produces an additional space

function celldata = vec2str(vecdata)

numdata=length(vecdata);
celldata=cell(1,numdata);

for i=1:numdata
    celldata{i}=num2str(vecdata(i));
end