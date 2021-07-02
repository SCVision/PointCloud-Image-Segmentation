function FileNames = get_FileName_from_Dir(FileDir, FileType)
% Function: convert file dir to file name
% Input:
%     FileDir -  the file dir
%     FileType - the file type
% Output:
%     FileNames - the file path
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

FileNames = {};
dirOutput = dir(fullfile(FileDir,['*.' FileType]));
FileBaseNames = {dirOutput.name};

% save file path
for i=1:numel(FileBaseNames)
    FileNames{i} = [FileDir '/' FileBaseNames{i}];
end