%connecting the webcam
webcamlist
%creating an object
cam = webcam(1);
for a = 1:10
img = snapshot(cam);
%imshow(img);
[rows, columns, numberOfColorBands] = size(img);
%converting RGB to HSV 
hsvImage = rgb2hsv(img);
%seperating the hue, saturation and value layers 
hImage = hsvImage(:,:,1);
sImage = hsvImage(:,:,2);
vImage = hsvImage(:,:,3);
%applying threshold values
hueThresholdvalueHigh = 1.0;
hueThresholdvalueLow = 0.05;
satuThresholdvalueHigh = 1.0;
satuThresholdvalueLow = 0.4;
valThresholdvalueHigh= 1.0;
valThresholdvalueLow = 0.2;
%finding the red area of the image
hueMask = (hImage>hueThresholdvalueLow) & (hImage<hueThresholdvalueHigh);
saturationMask = (sImage>satuThresholdvalueLow) & (sImage<satuThresholdvalueHigh);
valueMask = (vImage>valThresholdvalueLow) & (vImage<valThresholdvalueHigh);
%creating the binary image
ColoredObjectMask = uint8(hueMask & saturationMask & valueMask);
%filling small spaces
smallestAcceptableArea = 100;
ColoredObjectMask = uint8(bwareaopen(ColoredObjectMask,smallestAcceptableArea));
%smoothing the bodar
structuringElement = strel('disk', 4);
ColoredObjectMask = imclose(ColoredObjectMask, structuringElement);
%Fill any holes in the regions, since they are inside the wound.
ColoredObjectMask = imfill(logical(ColoredObjectMask),'holes');
ColoredObjectMask = cast(ColoredObjectMask,'like', img);
imshow(img,[]);
bw = ColoredObjectMask;
%Calculating the given properties of the binary image
ststs = regionprops(bw,'all');

%Drawing a circle for the red color area  
centers = ststs.Centroid;
diameters = mean([ststs.MajorAxisLength ststs.MinorAxisLength],2);
radii = diameters/2;
hold on
viscircles(centers,radii);
hold off
end
clear('cam');