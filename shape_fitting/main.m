[X,Y,Z] = meshgrid(-10:10,-11:12,-9:11);
[phi_init] = make_torus(6,4,X,Y,Z);

alpha = 0.12;
beta =0;gamma=0; a=0;b=0;c=0;r=1;
[psi0] = transform_surface( phi_init,alpha,beta,gamma,a,b,c,r,X,Y,Z );
phi = phi_init;
alpha0=0;beta0=0;gamma0=0;a0=0;b0=0;c0=0;r0=1;
dt = 0.000001;
for i=1:30
    [shape_dist,dalpha0_dt] = register_surface( phi,psi0,alpha0,beta0,gamma0,a0,b0,c0,r0,X,Y,Z );
    alpha0 = alpha0 + dalpha0_dt*dt;
    psi0 = transform_surface( psi0, alpha0,beta0,gamma0,a0,b0,c0,r0,X,Y,Z );
   
    
end