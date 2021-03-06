% check for info
if ~exist( 'dinoFileRead.m', 'file' )
    addpath( '/home/mbrophy/ComputerScience/LevelSetsAOS3D/' );
end
if ~exist( 'ac_GAC_model.m', 'file' )
    addpath( '/home/mbrophy/ComputerScience/AOSLevelSetSegmentationToolbox/' );
end
if ~exist( 'getCameraCenter.m', 'file' )
    addpath( '/home/mbrophy/ComputerScience/LevelSetsSegmentation/');
end
if ~exist( 'getCorrelationScore.m', 'file' )
    addpath( '/home/mbrophy/ComputerScience/Visibility/' );
end

% read Middlebury data
[s,Pcell,numImages] = dinoFileRead( );

%obtain camera centers
c = cell( numImages,1);
image = cell(numImages,1);
for index=1:numImages
    projMat = Pcell{index};
    [camx,camy,camz] = getCameraCenter( projMat );
    c{index} = [camx,camy,camz];
    filename = sprintf( '/home/mbrophy/ComputerScience/dinoRing/dinoR%04d.png', index );
    image{index,1} = im2double( rgb2gray( imread( filename ) ) );
    
end

phi = getSignedDistanceFunctionFromVisualHull( visHull );
visHullInv = double(~visHull);

Nx = 100; Ny = 100; Nz = 100;
x_lo = -0.1;%-0.08;
x_hi = 0.1;%0.05; 
y_lo = -0.1;%-0.03;
y_hi = 0.1;%0.09; 
z_lo = -0.1;%-0.08;
z_hi = 0.1;%0.03;
dx = (x_hi-x_lo)/Nx;
dy = (y_hi-y_lo)/Ny;
dz = (z_hi-z_lo)/Nz;
dX = [dx dy dz];
X = (x_lo:dx:x_hi)';
Y = (y_lo:dy:y_hi)';
Z = (z_lo:dz:z_hi)';
[x,y,z] = meshgrid(X,Y,Z);

% now calculate the surface normals of the visual hull
[normx,normy,normz] = normals3d( phi );


isFrontFacing = zeros( numImages,1 );
xc = -1*ones(size(phi));
numCorrelatedImages = -1*ones(size(phi));
%now, using these normals, calculate the relevant cameras
for p = 1:size(phi,1)
    for q = 1:size(phi,2)
        for r = 1:size(phi,3)
            % is on, or near, zero level set
            if( (phi(p,q,r) >= -3.0) && (phi(p,q,r) <= 3.0) )
                % calculate front-facing cameras
                X_i = [ x(p,q,r) ; y(p,q,r) ; z(p,q,r) ];
                N_i = [ normx(p,q,r) ; normy(p,q,r) ; normz(p,q,r) ];
                for index=1:numImages
                    camCenter = [c{index}(1) ; c{index}(2) ; c{index}(3) ];
                    isFrontFacing(index) = isFrontFacingCamera( X_i, N_i, camCenter );
                end
                % now get the correlation value
                [xc(p,q,r),numCorrelatedImages(p,q,r)] = ...
                    getCorrelationScore( X_i, Pcell, image, numImages, isFrontFacing, c );
            end
        end
    end
end

