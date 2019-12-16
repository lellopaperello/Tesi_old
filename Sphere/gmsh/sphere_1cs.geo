// Gmsh project created on Tue Dec 10 17:04:54 2019
SetFactory("OpenCASCADE");
//+
/* Parameters ----------------------------------------------------------------*/
scale = 4;
lc_s = 5e-3*scale;    lc_c = 1e-2*scale;    lc_b = 3;

/* Geometry ------------------------------------------------------------------*/
Sphere(1) = {0, 0, 0, 0.5,  -Pi/2, Pi/2, 2*Pi};
Sphere(2) = {0, 0, 0, 0.55, -Pi/2, Pi/2, 2*Pi};
Sphere(3) = {0, 0, 0, 15,   -Pi/2, Pi/2, 2*Pi};
//+
BooleanDifference{ Volume{3}; Delete; }{ Volume{2}; }
BooleanDifference{ Volume{2}; Delete; }{ Volume{1}; Delete; }
//+

// Physical Entities ---------------------------------------------------------*/
Physical Volume("domain") = {2, 3};

Physical Surface("sphere") = {1};
Physical Surface("boundary") = {3};

/* Mesh ----------------------------------------------------------------------*/
Characteristic Length {1, 2} = lc_s;
Characteristic Length {3, 4} = lc_c;
Characteristic Length {5, 6} = lc_b;
