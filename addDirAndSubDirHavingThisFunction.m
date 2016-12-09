function [] = addDirAndSubDirHavingThisFunction()
    CurrentFileLocation = mfilename('fullpath');
    [path, ~, ~] = fileparts(CurrentFileLocation);
    addpath(genpath(path));
end