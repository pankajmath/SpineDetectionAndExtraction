% Read an ITK-style MHD and load raw data from its associated RAW file
% Doesn't take LSB/MSB into account, but has some support for other
% datatypes. (Add support in switch statement below.)
% 
% Currently supports: MET_UCHAR, MET_USHORT, MET_ULONG, MET_UINT, MET_FLOAT
% and 'ElementByteOrderMSB' field.
%
% Returns fname=='' on failure, otherwise genuine raw data filename.
%
% If cast is specified, will cast result to that type regardless of 
% type stored in file
% July 2007     : Looks automatically for the extension mhd
% July 2006     : Returns spacing 
% July 2006     : isWinORUnixPathWithFile included so is plataform
% independent
% Jan 2003.    : Supports relative path
% Feb. 28, 2005: Supports ElementByteOrderMSB field.
 
function [data, spacingOut] = RAWfromMHD(filename, cast, relpativePath)
if strcmp(filename(end-3:end),'.raw')
    filename(end-3:end) = '.mhd';
end
DEBUG=0;
    data = -1;
    fname = '';
     % Relative path. Alberto Jan 2006
    
    if (exist('relpativePath','var'))
            filename =  isWinORUnixPathWithFile(relpativePath,filename );
    end   
    
    
    if(DEBUG); disp(filename); end;    
    
      
    %Alberto
    if exist(filename,'file')
        % Do nothing, we are OK!
    elseif exist( [filename '.mhd' ],'file')
        % Add the extension
        filename = [filename , '.mhd'  ];
    else
        emsg = sprintf('Couldn''t open file "%s"', filename);
        error(emsg);
    end
            
    
    mhd = fopen(filename, 'rt');
    if (mhd == -1)
        emsg = sprintf('Couldn''t open file "%s"', filename);
        error(emsg);
        return
    end
    
    % False==do not flip byte order
    byteOrder = false;
    
    while (~feof(mhd))
        % e.g., 'NDims = 3'
        line = fgetl(mhd);
        p = find(line == '=');
        lhs = line(1:p-2);
        rhs = line(p+2:end);
        
        switch (lhs)
            case 'NDims'
                NDims = rhs;
            case 'ElementType'
                elType = rhs;
            case 'DimSize'
                DimSize = rhs;
            case 'ElementDataFile'
                dataFile = rhs;
            case 'ElementByteOrderMSB'
                if (strcmpi(rhs,'true')), byteOrder = true; end
            %Alberto July 2006
            case 'ElementSpacing'                
                spacingString = rhs;
        end
    end
    fclose(mhd);
    
     %Alberto and Shan, July 07
     if (~exist('spacingString','var') )
         % This is the default spacing out
         spacingOut = [1 1 1];
     else
         %Otherwise, the output is the given space
         spacingOut = str2num(spacingString);
    end     

    
    % One thing not defined?
    if (~exist('NDims','var') || ~exist('elType','var') || ...
        ~exist('DimSize','var') || ~exist('dataFile','var'))
        fprintf('One or more fields undefined in MHD.\n');
        return
    end
    
    % Find matlab data type associated with type here
    switch (elType)
        case 'MET_UCHAR'
            elType = 'uint8';
        case 'MET_SHORT'
            elType = 'int16';
        case 'MET_USHORT'
            elType = 'uint16';
        case 'MET_ULONG'
            elType = 'uint32';
        case 'MET_UINT'
            elType = 'uint32';
        case 'MET_FLOAT'
            elType = 'float32';
        case 'MET_DOUBLE'
            elType = 'float64';            
        otherwise
            fprintf('Unknown data type: %s\nPlease add this type to RAWfromMHD.\n', elType);
            return
    end
    
    % Forcing cast?  %Added the option is empty
    if (exist('cast','var') & ~isempty(cast) )
        elType = sprintf('%s=>%s', elType, cast)
    else
        elType = [ '*' elType ];
    end
    
    % Get dimensions
    NDims = str2num(NDims);
    DimSize = sscanf(DimSize, '%d', [1 NDims]);
    
    %Alberto Jan 2006
    if (exist('relpativePath','var'))
        % dataFile = [relpativePath, dataFile ];
        dataFile =  isWinORUnixPathWithFile(relpativePath,dataFile );
    end      
    
    % Open...
    rawfile = fopen(dataFile, 'rb');    
    if (rawfile == -1)
        emsg = sprintf('Failure: Could not open "%s"', dataFile);
        error(emsg);
    end
    
    % Handle byte ordering
    if (byteOrder)
        % Big-endian
        byteOrder = 'ieee-be';
    else
        % Little-endian
        byteOrder = 'ieee-le';
    end
    
    % Handle different dimensions
    if (length(DimSize) ~= 1)
        data = fread(rawfile, prod(DimSize), elType, byteOrder);
        data = reshape(data, DimSize);
    else
        data = fread(rawfile, prod(DimSize), elType, byteOrder);
        if (numel(DimSize)==1)
            data = data';
        end
    end
    
    fclose(rawfile);

    % Done
    fname = dataFile;
return
