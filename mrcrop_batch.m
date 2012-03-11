function mrcrop_batch( inDir, newSizeX, newSizeY )
%MRCROP_BATCH Summary of this function goes here
%   Detailed explanation goes here
%   author: Konrad Werys (konradwerys@gmail.com)


files = get_all_files(inDir);
if ~exist('newSizeX','var') || ~exist('newSizeY','var')
    newSizeX=128;
    newSizeY=128;
    disp(['Default crop size: ',num2str([newSizeX,newSizeY])])

nFiles=size(files,1);
for iFile=1:nFiles
    [dirName, fileName, ~] = fileparts(cell2mat(files(iFile)));
    if strcmp(fileName,'dcmData')
        load(cell2mat(files(iFile)))
        imshow(dcmData(:,:,1,1),[])
        title([num2str(iFile),'/',num2str(nFiles)])
        rectX=(size(dcmData,1)-newSizeX)/2;
        rectY=(size(dcmData,2)-newSizeY)/2;
        rec=imrect(gca,[rectX,rectY,newSizeX,newSizeY]);
        rec.setResizable(0);
        wait(rec);
        if rec.isvalid
            pos=round(rec.getPosition());
            mrData=dcmData(pos(2):(pos(2)+pos(4)-1),pos(1):(pos(1)+pos(3)-1),:,:);
            
            try 
                myPath=fullfile(dirName,'mrData.mat');
                save(myPath,'mrData')
                disp(['Saved: ', myPath])
            end
        else
            disp(['No action: ',myPath])
        end
        clear dcmData dcmTags
    else
        disp(['Not a dcmData file: ',cell2mat(files(iFile))])
    end
end

end

