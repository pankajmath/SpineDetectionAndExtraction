function currentPath = isWinORUnixPathWithFile(path,fName)

   % If pwd is empty return fName as the path
    if( ~isempty(path))
	    if (isunix)
		% If the path alrady has '/' then remove it
		if strcmp (path(end),'/')
		    path = path(1:end-1);
		end

		currentPath         = [path,'/',fName];
	    end
	    if (ispc)
		% If the path alrady has '\' then remove it
		if strcmp (path(end),'\')
		    path = path(1:end-1);
		end
		currentPath         = [path,'\',fName];
	    end
     else
		currentPath = fName;	
     end
    

return