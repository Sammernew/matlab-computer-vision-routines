function [normGradPhiX,normGradPhiY,normGradPhiZ] = normals3d( phi ) 

    [gradPhiX gradPhiY,gradPhiZ]=gradient(phi);
    % magnitude of gradient of phi
    absGradPhi=sqrt(gradPhiX.^2 + gradPhiY.^2 + gradPhiZ.^2 );
    % normalized gradient of phi - eliminating singularities
    normGradPhiX=gradPhiX./(absGradPhi+(absGradPhi==0));
    normGradPhiY=gradPhiY./(absGradPhi+(absGradPhi==0));
    normGradPhiZ=gradPhiZ./(absGradPhi+(absGradPhi==0));
    %imagesc( normGradPhiX) 
    
    % added on Jan 21, 2009 -- forgot the change direction of normal!
    normGradPhiX = -normGradPhiX;
    normGradPhiY = -normGradPhiY;
    normGradPhiZ = -normGradPhiZ;
    %contour( phi ), hold on,
    %quiver3( normGradPhiX, normGradPhiY, normGradPhiZ ), hold off
end