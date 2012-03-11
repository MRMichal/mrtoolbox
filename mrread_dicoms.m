function [dcmData,dcmTags] = mrread_dicoms(inDir)
%MRREAD_DICOMS simply loads dicoms form direcory inDir
%
%   author: Konrad Werys (konradwerys@gmail.com)

dcmData=[];
dcmTags=[];

myFiles=dir(inDir);

k=0; % dicom counter
for iFile=1:size(myFiles,1)
    try
        % DICOM metadata
        meta = dicominfo(fullfile(inDir,myFiles(iFile).name)); 
    catch ex %#ok
        %disp([myFiles(iFile).name,' is not a Dicom. Error:',ex.message]);
        continue
    end
    k=k+1; % dicom counter
    if isnumeric(meta.InstanceNumber)
        try
            dcmData(:,:,1,meta.InstanceNumber) = dicomread(fullfile(inDir,myFiles(iFile).name)); %#ok
            dcmTags{1,meta.InstanceNumber} = dicominfo(fullfile(inDir,myFiles(iFile).name)); %#ok
        catch ex
            fprintf('\iFile')
            disp([myFiles(iFile).name,' Error: ',ex.message])
        end
    else
        keyboard
    end
    %disp([myFiles(iFile).name,' loaded. Series: ',num2str(meta.SeriesNumber)]);
end
%disp([num2str(k),' dicoms loaded.'])

