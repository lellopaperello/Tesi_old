// Gmsh project created on Mon Dec 16 19:44:59 2019
SetFactory("OpenCASCADE");
//+
/* Parameters ----------------------------------------------------------------*/
scale = 4;
lc_s = 2e-2*scale;    lc_1 = 2*lc_s;    lc_2 = 10*lc_1;   lc_b = 10;

/* Geometry ------------------------------------------------------------------*/
// Spherocylinder - wall
Cylinder(1) = {-5, 0, 0, 10, 0, 0, 1, 2*Pi};
Sphere(2) = {-5, 0, 0, 1, -Pi/2, Pi/2, 2*Pi};
Sphere(3) = {5, 0, 0, 1, -Pi/2, Pi/2, 2*Pi};

BooleanUnion{ Volume{1}; Delete; }{ Volume{3}; Volume{2}; Delete; }

// Control Volume 1 - Spherocylinder
Dilate {{0, 0, 0}, {1.05, 1.1, 1.1}} {
  Duplicata { Volume{1}; }
}

// Control Volume 2 - Sphere
Sphere(3) = {0, 0, 0, 7, -Pi/2, Pi/2, 2*Pi};

// Outer Boundary
Sphere(4) = {0, 0, 0, 90, -Pi/2, Pi/2, 2*Pi};

// Volumes definition
BooleanDifference{ Volume{4}; Delete; }{ Volume{3}; }
BooleanDifference{ Volume{3}; Delete; }{ Volume{2}; }
BooleanDifference{ Volume{2}; Delete; }{ Volume{1}; Delete; }

/* Physical Entities ---------------------------------------------------------*/
Physical Surface("spherocylinder") = {1, 2, 3, 4};
Physical Surface("control 1") = {6, 5, 7, 8};
Physical Surface("control 2") = {9};
Physical Surface("boundary") = {10};

/* Mesh ----------------------------------------------------------------------*/
Characteristic Length {1, 2, 3, 4} = lc_s;
Characteristic Length {5, 6, 7, 8} = lc_1;
Characteristic Length {9, 10} = lc_2;
Characteristic Length {11, 12} = lc_b;
