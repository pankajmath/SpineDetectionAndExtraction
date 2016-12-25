% Write a raw file and associated MHD.
% Format: WriteRAWandMHD(array, filePrefix,relpativePath)
% July.  isWinORUnixPathWithFile function added so is fully compatible in
% Unix and Windows
% Jan 2006. Support for relative paths
% November 16: Changed so that extension is removed automatically if
% present.
%
function WriteRAWandMHD(X, filePrefix,relpativePath,spacing)
    % Already have an extension? Remove it...
    f = find(filePrefix == '.', 1, 'last');
    if (~isempty(f))
        filePrefix = filePrefix(1 : f-1);
    end

    %Checks Spacing
    spacingOut=[1 1 1];    
    if (exist('spacing','var'))
        spacingOut = spacing;
    end     
 
    mhdFile = [ filePrefix '.mhd' ];
    rawFile = [ filePrefix '.raw' ];
    
    elType = class(X);
    switch elType
        case 'int16'
            elTypeOut.mhd = 'MET_SHORT';
        case 'uint8'
            elTypeOut.mhd = 'MET_UCHAR';
            elTypeOut.vvi =  3;                        
        case 'uint16'
            elTypeOut.mhd = 'MET_USHORT';
            elTypeOut.vvi =  5;              
        case 'uint32'
            elTypeOut.mhd = 'MET_ULONG';
            elTypeOut.vvi =  9;                          
        case 'single'
            elTypeOut.mhd = 'MET_FLOAT';
            elTypeOut.vvi =  8;            
        case 'double'
            elTypeOut.mhd = 'MET_DOUBLE';
            elTypeOut.vvi =  8;      
        case 'logical'
            elTypeOut.mhd = 'MET_UCHAR';
            elTypeOut.vvi =  3;                                    
        otherwise
            outstr = sprintf('Data type unknown ("%s") - please modify WriteRAWandMHD.', elType);
            error(outstr);
    end
    % Open file in the destination
    % Relative path. Alberto Jan 2006
    if (exist('relpativePath','var'))
        mhdFileWithPath =  isWinORUnixPathWithFile( relpativePath,mhdFile );        
        mhd = fopen(mhdFileWithPath, 'wt');                        
    else
        mhd = fopen(mhdFile, 'wt');            
    end   
    %Write mhd file
    fprintf(mhd, 'ObjectType = Image\n');
    fprintf(mhd, 'NDims = 3\n');
    fprintf(mhd, 'BinaryData = True\n');
    fprintf(mhd, 'BinaryDataByteOrderMSB = False\n');
    fprintf(mhd, 'ElementSpacing =  %4.4f  %4.4f   %4.4f \n', spacingOut(1), spacingOut(2), spacingOut(3));    
    fprintf(mhd, 'DimSize = %d %d %d\n', size(X,1), size(X,2), size(X,3));
    fprintf(mhd, 'ElementType = %s\n', elTypeOut.mhd);
    fprintf(mhd, 'ElementDataFile = %s\n', rawFile);
    fclose(mhd);

    %Write raw file
    % Relative path. Alberto Jan 2006
    if (exist('relpativePath','var'))
        rawFileWithPath =  isWinORUnixPathWithFile( relpativePath,rawFile );    
        raw = fopen(rawFileWithPath, 'wb');                        
    else
        raw = fopen(rawFile, 'wb');    
    end   
    fwrite(raw, X, class(X)); 
    fclose(raw);
    
    
%     %write vvi file
%     vviFile = [filePrefix '.raw.vvi'];
%     if (exist('relpativePath','var'))
%         fid = fopen([relpativePath, vviFile ], 'wt');                        
%     else
%         fid = fopen(vviFile,'wt');        
%     end   
%     fprintf(fid, '<VVOpenWizard Version = "1.8"\n');
%     fprintf(fid, '\t\tSpacing = %4.4f %4.4f %4.4f"\n', spacingOut(1), spacingOut(2), spacingOut(3));        
%     fprintf(fid, '\t\tOrigin = "0 0 0"\n');
%     fprintf(fid, '\t\tScalarType = "%d"\n',elTypeOut.vvi);
%     fprintf(fid, '\t\tWholeExtent = "0 %d 0 %d 0 %d"\n',size(X,1)-1,size(X,2)-1,size(X,3)-1);
%     fprintf(fid, '\t\tNumberOfScalarComponents = "1"\n');
%     fprintf(fid, '\t\tIndependantComponents = "1"\n');
%     fprintf(fid, '\t\tFileOrientation = "10 2 0"\n');
%     fprintf(fid, '\t\tBigEndianFlag = "0"\n');
%     fprintf(fid, '\t\tFilePattern = "%s"\n',rawFile);
%     fprintf(fid, '\t\tFileDimensionality = "3"/>\n');
%     fclose(fid);
    
%     %write Amira script
%     hxFile = [filePrefix '.hx'];
%     fid = fopen(hxFile,'wt');    
%     fprintf(fid, '# Amira Script\n');
%     fprintf(fid, 'remove -all\n');
%     fprintf(fid, 'remove %s\n',rawFile);
% 
%     fprintf(fid, '# Create viewers\n');
%     fprintf(fid, 'viewer setVertical 0\n');
% 
%     fprintf(fid, 'viewer 0 setBackgroundMode 1\n');
%     fprintf(fid, 'viewer 0 setBackgroundColor 0.06 0.13 0.24\n');
%     fprintf(fid, 'viewer 0 setBackgroundColor2 0.72 0.72 0.78\n');
%     fprintf(fid, 'viewer 0 setTransparencyType 5\n');
%     fprintf(fid, 'viewer 0 setAutoRedraw 0\n');
%     fprintf(fid, 'viewer 0 show\n');
%     fprintf(fid, 'mainWindow show\n');
% 
%     fprintf(fid, 'set hideNewModules 0\n');
%     fprintf(fid, '[ load -raw ${SCRIPTDIR}/%s little xfastest float 1 %d %d %d 0 %d 0 %d 0 %d ] setLabel %s\n', ...
%       rawFile,size(X,1),size(X,2),size(X,3),size(X,1)-1,size(X,2)-1,size(X,3)-1,  rawFile);
%     fprintf(fid, '%s setIconPosition 20 10\n');
%     fprintf(fid, '%s fire\n',rawFile);
%     fprintf(fid, '%s fire\n',rawFile);
%     fprintf(fid, '%s setViewerMask 65535\n',rawFile);
%     fprintf(fid, '%s select\n',rawFile);
% 
%     fprintf(fid, 'set hideNewModules 0\n');
% 
% 
%     fprintf(fid, 'viewer 0 setCameraPosition 147.835 58.8105 31.75\n');
%     fprintf(fid, 'viewer 0 setCameraOrientation 0.57735 0.57735 0.57735 2.0944\n');
%     fprintf(fid, 'viewer 0 setCameraFocalDistance 89.0248\n');
%     fprintf(fid, 'viewer 0 setAutoRedraw 1\n');
%     fprintf(fid, 'viewer 0 redraw\n');
%     fclose(fid);
    
return
