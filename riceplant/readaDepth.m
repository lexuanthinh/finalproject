function readaDepth
    close all
   istart = 100;
   nframe = 25;
   
   for i=istart:istart+nframe-1
       depthname = strcat('./Kinect2Data.3/',num2str(i),'_depth2rgb.bin');
       rgbname = strcat('./Kinect2Data.3/',num2str(i),'_rgb.png');
       ptCloud = readfileDepth(depthname,rgbname);
       
       if i==istart
        ptAll = copy(ptCloud);
        
       else
        %ptAll = pcmerge(ptAll,ptCloud,1);
        tform = pcregrigid(pcLast,ptCloud,'Extrapolate',true);
        disp(tform.T);
        ptCloudAligned = pctransform(ptCloud,tform);
        ptAll = pcmerge(ptAll,ptCloudAligned,1);
       end
       pcLast = ptCloud;
       figure(111)
       set(gcf,'Position',[100 100 1000 800]);
       hAxes = pcshow(ptAll,'VerticalAxis','Y', 'VerticalAxisDir', 'Down');
       hAxes.CameraViewAngleMode = 'auto';
       pause
   end

function [ptCloud] = readfileDepth(fname,rgbname)
    %close all
    fp=fopen(fname);
    data=fread(fp,2,'int');
    width = data(1)
    height = data(2)
    
    B = fread(fp,Inf,'float');
    imageOut = reshape(B,[width,height])';
    
    fclose(fp);
    
    %figure(555)
    %imagesc(imageOut)
    %axis image;
    
    %%% point cloud render
     [xx,yy] = meshgrid(1:2:width, 1:2:height);
     
     size(xx)
     size(yy)
     imageOut = imresize(imageOut,[size(xx,1) size(xx,2)]);
     size(imageOut)
     
     %figure(666)
     
     RGBImg = imread(rgbname);
     RGBImg = reshape(imresize(RGBImg,[size(xx,1) size(xx,2)]),[],3);
     
     %pcshow([xx(:),yy(:),imageOut(:)],RGBImg);
     
     startpoint = 200000;
     endpoint = 400000;
     xyzPoints = [xx(startpoint:endpoint)', yy(startpoint:endpoint)', imageOut(startpoint:endpoint)'];
     colorPoints = RGBImg(startpoint:endpoint,:);
     ptCloud  = pointCloud(xyzPoints,'color',colorPoints);
     %ptCloud  = pointCloud(xyzPoints);
     %figure(666)
     %pcshow(ptCloud);
     
     