// Gmsh project created on Mon Dec  9 10:44:41 2019
SetFactory("OpenCASCADE");
//+
/* Parameters ----------------------------------------------------------------*/
scale = 2;
lc_c = 5e-4*scale;    lc_b = 2*scale;

/* Geometry ------------------------------------------------------------------*/
Circle(1) = {0, 0, 0, 0.5, 0, 2*Pi};
Circle(2) = {0, 0, 0, 15, 0, 2*Pi};

Curve Loop(1) = {1};
Curve Loop(2) = {2};
Plane Surface(1) = {2, 1};

/* Mesh ----------------------------------------------------------------------*/
Characteristic Length {1} = lc_c;
Characteristic Length {2} = lc_b;

/* Physical Entities ---------------------------------------------------------*/
Physical Surface("Domain") = {1};

Physical Curve("Cylinder") = {1};
Physical Curve("Boundary") = {2};

// Selecting Frontal-Delaunay Algorithm
Mesh.Algorithm = 6;
