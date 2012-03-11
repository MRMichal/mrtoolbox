function mrdicom2matlab( inDir, outDir )
%MRDICOM2MATLAB sorts dicoms based on the information from metadata
%   Creates new file structure: 
%   -patient name
%    -study name
%     -image name
%   DONT work well if many patients have the same name!!!
%   author: Konrad Werys (konradwerys@gmail.com)

% TODO % make it work when many patients have the same name!!!

myDirs=get_all_dirs(inDir);

tic
k=0; % dicom counter
for iDir=1:size(myDirs,1)
    [dcmData,dcmTags] = mrread_dicoms(myDirs{iDir});
    if ~isempty(dcmData) && ~isempty(dcmTags)
        myPath=mrfilepath_constructor(outDir,'dcmData.mat',dcmTags);
        % MATLAB forses us to check if file exist, doesn allow just append
        % to a non existing file
        if ~exist(myPath,'file')
            save(myPath,'dcmTags')
        else
            save(myPath,'dcmTags','-append')
        end
        save(myPath,'dcmData','-append')
        k=k+1; % dicom counter
    end
    clear dcmData dcmTags;
    fprintf('.')
    if k>1 && mod(k,floor((size(myDirs,1)-(iDir-k))/100))==0 
        fprintf('\n %2.0f%% Approx. remaining time: %.2f minutes',100*k/(size(myDirs,1)-(iDir-k)), toc*((size(myDirs,1)-(iDir-k))/k-1)/60 )
    end
end
fprintf('\n')
disp(['Time in minutes= ',num2str(toc/60)])
disp([num2str(k),' studies loaded'])

end

