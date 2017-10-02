im1=imread('/Users/matthew/Desktop/MAX_Image 455.png');
im2=imread('/Users/matthew/Desktop/MAX_Image 456.png');
im3=imread('/Users/matthew/Desktop/82.png');

stack1 = '/Users/matthew/Desktop/stack1';
stack2 = '/Users/matthew/Desktop/stack2';
stack3 = '/Users/matthew/Desktop/stack3';

destinationStack1 = '/Users/matthew/Desktop/stack1Out';
destinationStack2 = '/Users/matthew/Desktop/stack2Out';
destinationStack3 = '/Users/matthew/Desktop/stack3Out';

if ~isdir(stack1)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', stack1);
  uiwait(warndlg(errorMessage));
  
end

if ~isdir(stack2)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', stack2);
  uiwait(warndlg(errorMessage));
  
end

if ~isdir(destinationStack1)
  mkdir(destinationStack1);
end
if ~isdir(destinationStack2)
  mkdir(destinationStack2);
end

im1f=figure; imshow(im1);
im2f=figure; imshow(im2);
figure(im1f), [x1,y1] = getpts;
figure(im2f), [x2,y2] = getpts;
figure(im1f), hold on, plot(x1,y1,'oy', 'LineWidth', 5, 'MarkerSize', 10);
figure(im2f), hold on, plot(x2,y2,'oy', 'LineWidth', 5, 'MarkerSize', 10);
T=maketform('projective',[x2 y2],[x1 y1]);
T.tdata.T;
[im2t,xdataim2t,ydataim2t]=imtransform(im2,T);
% now xdataim2t and ydataim2t store the bounds of the transformed im2
xdataout=[min(1,xdataim2t(1)) max(size(im1,2),xdataim2t(2))];
ydataout=[min(1,ydataim2t(1)) max(size(im1,1),ydataim2t(2))];
% let's transform both images with the computed xdata and ydata
im2t=imtransform(im2,T,'XData',xdataout,'YData',ydataout);
im1t=imtransform(im1,maketform('affine',eye(3)),'XData',xdataout,'YData',ydataout);

filePattern1 = fullfile(stack1, '*.png');
filePattern2 = fullfile(stack2, '*.png');

theFiles = dir(filePattern1);
for k = 1 : length(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(stack1, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  tempImg = imread(fullFileName);
  tempImgt = imtransform(tempImg,maketform('affine',eye(3)),'XData',xdataout,'YData',ydataout);
  fullDestinationFileName = fullfile(destinationStack1, baseFileName);
  imwrite(tempImgt, fullDestinationFileName);
end

theFiles = dir(filePattern2);
for k = 1 : length(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(stack2, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  tempImg = imread(fullFileName);
  tempImgt = imtransform(tempImg,T,'XData',xdataout,'YData',ydataout);
  fullDestinationFileName = fullfile(destinationStack2, baseFileName);
  imwrite(tempImgt, fullDestinationFileName);
end

ims=max(im1t,im2t);
im2f=figure; imshow(ims);

choice = questdlg('Is there a 3rd image?', ...
	'Continue?', ...
	'Yes','No','No');

switch choice
    case 'Yes'
        if ~isdir(stack3)
            errorMessage = sprintf('Error: The following folder does not exist:\n%s', stack3);
            uiwait(warndlg(errorMessage));
            return;
        end
        if ~isdir(destinationStack3)
            mkdir(destinationsStack3);
        end
        fprintf('Select points');
    case 'No'
        return;
end
   
im3f=figure; imshow(im3);
figure(im2f), [x3,y3]=getpts
figure(im3f), [x4,y4]=getpts
figure(im2f), hold on, plot(x3,y3,'oy', 'LineWidth', 5, 'MarkerSize', 10);
figure(im3f), hold on, plot(x4,y4,'oy', 'LineWidth', 5, 'MarkerSize', 10);
D=maketform('projective',[x4 y4],[x3 y3]);
D.tdata.T;
[im3t,xdataim3t,ydataim3t]=imtransform(im3,D);
% now xdataim2t and ydataim2t store the bounds of the transformed im2
xdataout2=[min(1,xdataim3t(1)) max(size(ims,2),xdataim3t(2))];
ydataout2=[min(1,ydataim3t(1)) max(size(ims,1),ydataim3t(2))];
% let's transform both images with the computed xdata and ydata
im3t=imtransform(im3,D,'XData',xdataout2,'YData',ydataout2);


filePattern = fullfile(stack3, '*.png');

theFiles = dir(filePattern3);
for k = 1 : length(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(stack3, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  tempImg = imread(fullFileName);
  tempImgt = imtransform(tempImg,D,'XData',xdataout2,'YData',ydataout2);
  fullDestinationFileName = fullfile(destinationStack3, baseFileName);
  imwrite(tempImgt, fullDestinationFileName);
end

imst=imtransform(ims,maketform('affine',eye(3)),'XData',xdataout2,'YData',ydataout2);
padsizex = abs(size(imst,1)-size(im3t,1));
padsizey = abs((size(imst,2)-size(im3t,2)));
A = padarray(im3t,[padsizex padsizey],'post');
%1-67, 68-141, 142-213

ims2=max(A,imst);
figure, imshow(ims2);


