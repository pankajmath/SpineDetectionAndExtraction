function delete_RAW(file_path,file_name)
delete(fullfile(file_path,[file_name '.RAW']));
delete(fullfile(file_path,[file_name '.mhd']));
end