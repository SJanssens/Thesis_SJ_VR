function n_masterframes=change_masterframe(L,masterframes)

%delete slotvalues
%find frame
for i=1:length(L)
    if length(masterframes.convlist.frameindex)<2
        framenumber(i)=1;
    else
        startpoints=masterframes.convlist.frameindex';
        endpoints=[masterframes.convlist.frameindex(2:end)'-1 masterframes.numvalues];
    
        for j=1:length(startpoints)
            if any(ismember(startpoints(j):endpoints(j),L(i)))
            framenumber(i)=j;
            end
        end
    end
end
    

 for i=1:length(L)
        startpoints=masterframes.convlist.frame(framenumber(i)).fieldindex';
        if length(startpoints)==1 && framenumber(i)~=masterframes.numframes
           endpoints=[masterframes.convlist.frame(framenumber(i)+1).fieldindex(1)-1];
        end
        
        if length(startpoints)>1 && framenumber(i)~=masterframes.numframes
           endpoints=[masterframes.convlist.frame(framenumber(i)).fieldindex(2:end)'-1 masterframes.convlist.frame(framenumber(i)+1).fieldindex(1)-1];
        end
        if length(startpoints)==1 && framenumber(i)==masterframes.numframes
           endpoints=[masterframes.numvalues];
        end
        if length(startpoints)>1 && framenumber(i)==masterframes.numframes
           endpoints=[masterframes.convlist.frame(framenumber(i)).fieldindex(2:end)'-1 masterframes.numvalues];
        end
             
        for j=1:length(startpoints)
            if any(ismember(startpoints(j):endpoints(j),L(i)))
                frameslotnumber(i)=j;
                frameslotvaluenumber(i)=find(ismember(startpoints(j):endpoints(j),L(i)));
            end
        end
   
 end
 
 
frameslotvalues=cell(max(framenumber), max(frameslotnumber));
 for i=1:length(L) 
      frameslotvalues{framenumber(i),frameslotnumber(i)}=[frameslotvalues{framenumber(i),frameslotnumber(i)} frameslotvaluenumber(i)];
 end
 
 
 temp_masterframes=masterframes;
 for i=1:max(framenumber)
     for j=1:max(frameslotnumber)
         if ~isempty(frameslotvalues{i,j})
             if ~isempty(masterframes.frame(i).data)
                fnames = fieldnames(masterframes.frame(i).data);
                temp_masterframes.frame(i).data.(fnames{j})= ...
                setdiff(masterframes.frame(i).data.(fnames{j}), masterframes.frame(i).data.(fnames{j})(frameslotvalues{i,j}),'stable');%remove slotvalues. The stable flag ensures the setdiff returns the same order as in the original

             end
        end
     end
 end
 
  for i=1:max(framenumber)
     for j=1:max(frameslotnumber)
         if ~isempty(frameslotvalues{i,j})
             if ~isempty(masterframes.frame(i).data)
                 fnames = fieldnames(masterframes.frame(i).data);
                 if isempty(temp_masterframes.frame(i).data.(fnames{j}))
                    temp_masterframes.frame(i).data=rmfield(temp_masterframes.frame(i).data,fnames{j});
                end %remove slots if empty

             end
         end
     end
  end
 
 
 
 remove_frame=[];
  for i=1:max(framenumber)
      if ~isempty(frameslotvalues{i,1})
             if ~any(isfield(temp_masterframes.frame(i).data,masterframes.slotnames))
                remove_frame=[remove_frame i];
             end
      end
  end
  stay_frames=setdiff(1:masterframes.numframes,remove_frame,'stable');

  tmp2_masterframes.framenames=masterframes.framenames(stay_frames);
  for i=1:length(stay_frames)
    tmp2_masterframes.frame(i).data=temp_masterframes.frame(stay_frames(i)).data;
  end
  n_masterframes=tmp2_masterframes;
end