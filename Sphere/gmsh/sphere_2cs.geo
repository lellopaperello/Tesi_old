// Gmsh project created on Tue Dec 10 17:04:54 2019
SetFactory("OpenCASCADE");
//+
/* Parameters ----------------------------------------------------------------*/
scale = 6;
lc_s = 1e-3*scale;    lc_1 = 2*lc_s;    lc_2 = 10*lc_1;   lc_b = 2;

/* Geometry ------------------------------------------------------------------*/
Sphere(1) = {0, 0, 0, 0.5,  -Pi/2, Pi/2, 2*Pi};
Sphere(2) = {0, 0, 0, 0.55, -Pi/2, Pi/2, 2*Pi};
Sphere(3) = {0, 0, 0, 1,    -Pi/2, Pi/2, 2*Pi};
Sphere(4) = {0, 0, 0, 15,   -Pi/2, Pi/2, 2*Pi};
//+
BooleanDifference{ Volume{4}; Delete; }{ Volume{3}; }
BooleanDifference{ Volume{3}; Delete; }{ Volume{2}; }
BooleanDifference{ Volume{2}; Delete; }{ Volume{1}; Delete; }
//+

// Physical Entities ---------------------------------------------------------*/
Physical Volume("domain") = {2, 3, 4};

Physical Surface("sphere") = {1};
Physical Surface("boundary") = {3};

/* Mesh ----------------------------------------------------------------------*/
Characteristic Length {1, 2} = lc_s;
Characteristic Length {3, 4} = lc_1;
Characteristic Length {5, 6} = lc_2;
Characteristic Length {7, 8} = lc_b;
