function [myPath]=mrfilepath_constructor(outDir,fileName,dcmTags)
%MRFILEPATH_CONSTRUCTOR creates filepath based on DICOM metadata
%   author: Konrad Werys (konradwerys@gmail.com)

%%% retrive name
name=[];
if isfield(dcmTags{1}.PatientName,'FamilyName')
    name=[name,dcmTags{1}.PatientName.FamilyName,' '];
end
if isfield(dcmTags{1}.PatientName,'GivenName')
    name=[name,dcmTags{1}.PatientName.GivenName];
end

seriesNumber=[];
if isfield(dcmTags{1},'SeriesNumber')
    seriesNumber=[seriesNumber,dcmTags{1}.SeriesNumber];
end

seriesDescription=[];
if isfield(dcmTags{1},'SeriesDescription')
    seriesDescription=[seriesDescription,dcmTags{1}.SeriesDescription];
end

if isempty(name) || isempty(seriesDescription) || isempty(seriesNumber)
    disp(['Something is wrong with study: ',name,' ',seriesDescription,' ', num2str(seriesNumber),'. Data not saved!!!'])
    return
end

nameFolder = strtrim(name);
seriesFolder = sprintf('series_%03d_%s',seriesNumber,seriesDescription);
myPath=fullfile(outDir,nameFolder);
myPath=fullfile(myPath,seriesFolder);

% creates folder structure
if ~exist(myPath,'dir')
    try
        mkdir(myPath)
    catch ex
        disp(ex.message)
        myPath=[];
        return
    end
end


myPath=fullfile(myPath,fileName);

% if ~exist(myPath,'file')
%     try
%         save(myPath,'myPath')
%     catch ex
%         disp(ex.message)
%         myPath=[];
%         return
%     end
% end




