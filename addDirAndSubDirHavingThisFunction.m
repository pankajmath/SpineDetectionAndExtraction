function [] = addDirAndSubDirHavingThisFunction()
% This function adds all the folders and subfolders to matlab path
% starting from the present working directory
    [path, ~, ~] = fileparts(pwd);
    addpath(genpath(path));
end